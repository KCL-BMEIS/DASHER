#!/usr/bin/env python

'''export-anon-data.py
Sends anonymised ICR ROI assessodrs and scans to the anonymised XNAT

Usage:
    export-anon-data.py CT_ID CT_SUBJECT_LABEL CT_SESSION_LABEL PROJECT SUBJECT_ID SESSION_ID SESSION_DATE ANON_PATH ANON_PROJECT BENCHMARK

Options:
    CT_ID
    CT_SUBJECT_LABEL
    CT_SESSION_LABEL
    PROJECT                     Project of parent session
    SUBJECT_ID                  ID of parent subject
    SESSION_ID               Label of parent session
    SESSION_DATE
    ANON_PATH
    ANON_PROJECT
    BENCHMARK

'''

import os
import sys
import uuid
import pydicom
import logging
import subprocess
import shutil
from docopt import docopt
import zipfile
import requests
import json
import time
import datetime as dt

from os.path import basename
from lxml.builder import ElementMaker
from lxml.etree import tostring as xmltostring
from lxml import etree
import tempfile
from io import BytesIO
import configparser

#config = ConfigParser.RawConfigParser()
#config.read('/data/xnat/home/xnat.cfg')
server = 'http://localhost:8080' #config.get('xnat', 'xnat_host')
usr = os.environ['XNAT_ADMIN'] #  config.get('xnat', 'xnat_user')
pwd = os.environ['XNAT_ADMIN_PWD']  # config.get('xnat', 'xnat_pwd')



nsdict = {'xnat':'http://nrg.wustl.edu/xnat',
          'xsi':'http://www.w3.org/2001/XMLSchema-instance',
          'icr':'http://icr.ac.uk/icr',
          'clinicalTrials':'http://localhost:8080/clinicalTrials'}

xnat_host = os.environ.get('XNAT_HOST', 'http://nrg.wustl.edu')
schema_location_template = "{0} {1}/xapi/schemas/{2}/{2}.xsd "
schema_location = schema_location_template.format(nsdict['xnat'], xnat_host, 'xnat') + \
                  schema_location_template.format(nsdict['icr'], xnat_host, 'roi')

url_anon = "http://xnat-web2:8080/anon"
#url_local = "http://xnat-web1:8080"
url_local = "http://localhost:8080"


date_now = '{0:%Y-%m-%d}'.format(dt.datetime.now())
logfile = '/data/xnat/scripts/logs/export_anon_data_{}.log'.format(date_now)
logging.basicConfig(filename=logfile,  format='%(name)s - %(levelname)s - %(message)s', level=logging.INFO)
#logging.basicConfig(filename=logfile,  format='%(name)s - %(levelname)s - %(message)s', level=logging.DEBUG)





#### Find the RTSTRUCT file
tags = {
    'SeriesNumber': (0x0020, 0x0011),
    'SeriesDescription': (0x0008, 0x103E),
    'SOPInstanceUID': (0x0008, 0x0018),
    'StudyInstanceUID': (0x0020, 0x000D),
    'SeriesInstanceUID': (0x0020, 0x000E),
    'StudyDate': (0x0008, 0x0020),
    'StudyTime': (0x0008, 0x0030),
    'Modality': (0x0008, 0x0060),
    'DeidentificationMethod': (0x0012,0x0063),
    'RTROIObservationsSequence': (0x3006,0x0080),
    'StructureSetLabel': (0x3006, 0x0002),
    'ReferencedFrameOfReferenceSequence': (0x3006, 0x0010)
}

def getResearchSubjectID( url_local, project, subject_id,custom_var):
    #logging.debug("Finding Research Subject ID for {}".format(subject_id))
    url = '{}/data/archive/projects/{}/subjects/{}?format=xml'.format(url_local, project, subject_id)

    r = session_local.get(url)
    if custom_var in r.text:
        aa=r.text.split('</xnat:fields>')
        aa=aa[0].split(custom_var)
        aa=aa[1].split('-->')
        aa=aa[1].split('</xnat:field>')
        research_subject_id = aa[0]
        logging.info('Found existing research_subject_id: {}'.format(research_subject_id))
    else:
        random_id = '{}'.format(uuid.uuid4())
        research_subject_id = '{}'.format(random_id[:8])
    return research_subject_id         
    #logging.error('####################')
    # else generate new research_subject_id


def writeResearchSubjectID(url_local, project, subject_id,custom_var,research_subject_id):
    #write to cusotm variable!!
    url = "{}/data/archive/projects/{}/subjects/{}".format( url_local, project, subject_id)
    vals = { 'xnat:subjectData/fields/field[name={}]/field'.format(custom_var): '{}'.format(research_subject_id) }
    r = session_local.put(url,  data=vals)

    if r.status_code != 200:
        logging.error("ERROR: Write Research Subject ID error: {} - {} - {}".format(r.status_code, url, vals))
        sys.exit(20)


def zip_filename(session_label, scan_label, cache_path):
    zip_filename = "{}/{}{}.zip".format(cache_path, session_label,scan_label)
    return zip_filename
    

    

def parse_anonymised_directory(anon_path):
    #TODO: move the logging.errors up out of this file
    #logging.debug("Checking anonymisation is complete in all files... ")
    errors = []
    file_count = 0
    for root, dirs, files in os.walk(anon_path):
        for fp in files:
            isdicom, error = is_dicom_file(fp)
            if not isdicom:
                errors.append((fp, error))
                continue
            else:
                file_count = file_count + 1

            with open(os.path.join(root, fp), 'rb') as f:
                isanonymised, error =  is_anonymised(f)
                if not isanonymised:
                    errors.append((f, error))
    if file_count < 1:
        errors.append("No anonymised dicom files found")
    return len(errors) == 0, errors


def is_dicom_file(f):
    return (f.endswith('.dcm'), None)
    #TODO: worth extending this to perform the dcmread within a try/catch and
    #constructing a sensible error message to return with false


def is_anonymised(f):
    #TODO: move the fetching of the file entries to outside this function
    dicom = pydicom.dcmread(f, specific_tags=tags.keys())
    deidentified = dicom[tags['DeidentificationMethod']].value
    if 'Secure DICOM' not in deidentified:
        return False, 'Data not ANONYMISED, method contains: {}'.format(deidentified)
    if 'pydicom' not in deidentified:
        return False, 'Data not ANONYMISED, method contains: {}'.format(deidentified)
    return True, None

def find_anon_session(ct_subject_label,ct_session_label, url_anon, project):
    
    #logging.debug("Finding Anonymised Session ID for {}".format(ct_session_label))
    url = '{}/data/archive/projects/{}/subjects/{}/experiments?columns=xnat:imageSessionData/subject_ID,url,label&format=json'.format(url_anon, project, ct_subject_label)
    attempts=1
    while attempts<15:
        r = session.get(url)
        json_data = json.loads(r.text)
        for dat in json_data['ResultSet']['Result']:
            if ct_session_label in dat['label']:
                ct_session_id = '{}'.format(dat['session_ID'])
                ct_subject_id = '{}'.format(dat['xnat:imagesessiondata/subject_id'])
                xsiType  = '{}'.format(dat['xsiType'])
                #logging.debug("Found Session ID for {}: subId: {}   sesID: {}".format(ct_session_label, ct_subject_id, ct_session_id))
                return ct_subject_id,ct_session_id, xsiType
        attempts=attempts+1
        time.sleep(10)
    logging.error('Cannot find sesison, pipeline failed')
    return 0



def create_anon_session(anon_path,session, url, dt):
    r = session.delete(url)
    CT = False
    MR = False
    PET = False
    url2 = ''

    for root, dirs, files in os.walk(anon_path):
        for fl in files:
            if fl.endswith(".dcm"):
                with open(os.path.join(root,fl), 'rb') as f:

                    dicom = pydicom.dcmread(f)
                    #series_number = dicom[tags['SeriesNumber']].value
                    modality = dicom.Modality
                    studyUID = dicom.StudyInstanceUID
                    logging.debug("found file....{}   {}".format(modality, studyUID))

                    if 'CT' in modality and 'RT' not in modality:
                        url2 = "{}?xnat:ctSessionData/date={}".format(url, dt)
                        CT=True
                    if 'MR' in modality:
                        url2 = "{}?xnat:mrSessionData/date={}".format(url, dt)
                        MR=True
                    if 'PET' in modality:
                        url2 = "{}?xnat:petSessionData/date={}".format(url, dt)
                        PET=True


    if MR and PET:
        url2 = "{}?xnat:petmrSessionData/date={}".format(url, dt)
    if CT and PET:
        # NO PET CT - SO?????
        url2 = "{}?xnat:petSessionData/date={}".format(url, dt)
    #logging.info(anon_path)
    url2 = "{}&xnat:imageSessionData/UID={}".format(url2, studyUID)
    logging.debug("creating session: {}".format(url2))
    r = session.put(url2)
    if r.status_code != 201:
        logging.error("ERROR: cannot create anonymised  session: {} {} {}".format(url2, r.status_code, modality))
    else:
        #logging.debug("Creating PA session: {}".format(url2))
        return True
    return False




def ns(namespace,tag):
    return "{%s}%s"%(nsdict[namespace], tag)

def get_dicom_header_value(line):
    left_bracket_idx = line.find('[')
    right_bracket_idx = line.find(']')
    if left_bracket_idx == -1 or right_bracket_idx == -1:
        return None
    return line[left_bracket_idx + 1:right_bracket_idx]

version = "1.0"
args = docopt(__doc__, version=version)



#clinical trial subject and session ids
clinical_trial_id = args.get("CT_ID")
ct_subject_label = args.get("CT_SUBJECT_LABEL")
ct_session_label = args.get('CT_SESSION_LABEL')
project = args.get('PROJECT')
subject_id = args.get("SUBJECT_ID")
session_id = args.get('SESSION_ID')
session_date = args.get('SESSION_DATE')
anon_path = args.get('ANON_PATH')
anon_project = args.get('ANON_PROJECT')
benchmark = args.get('BENCHMARK')



#curl_params = "curl -u {}:{} -X ".format(usr,pwd)
ct_subject_id = ''
ct_sesison_id = ''
cache_path = '/data/xnat/cache/temp/{}{}/'.format(subject_id, session_id)

if not os.path.isdir(cache_path):
    os.mkdir(cache_path)

#until finished, use original
#anon_project=project

session = requests.Session()
session.auth = (usr, pwd)
auth = session.post(url_anon)

session_local = requests.Session()
session_local.auth = (usr, pwd)
auth_local = session_local.post(url_local)


## replace these with specifics:
dicom_path = ""
rt_num = 1
#logging.debug('#######################################################')
time_now = '{0:%H:%M}'.format(dt.datetime.now())
logging.info("############## {}: EXPORT ANON SCRIPT {} to {}#####################".format(time_now,session_id, ct_session_label  ))
#logging.debug("Debug: args " + ", ".join("{}={}".format(name, value) for name, value in args.items()) + "\n")


## IF GENERAL CLINICAL RESERACHM, GENERATE CT STUFF...

#anon_project=project

#anon_project='{}_Clinical_Trials'.format(project)
custom_var = 'research_subject_id'
if '__GENERATE__' in clinical_trial_id:
    ct_subject_label = getResearchSubjectID( url_local, project, subject_id,custom_var)
    writeResearchSubjectID(url_local, project, subject_id,custom_var,ct_subject_label)
    random_id = '{}'.format(uuid.uuid4())
    ct_session_label = '{}'.format(random_id[:8])
    clinical_trial_id = '_RESEARCH_'  #{}'.format( uuid.uuid4())
    #anon_project='{}_Research'.format(project)

elif '_RESEARCH_' in clinical_trial_id:
    writeResearchSubjectID( url_local, project, subject_id,custom_var,ct_subject_label)
    clinical_trial_id = '_RESEARCH_'  #{}'.format( uuid.uuid4())
    #anon_project='{}_Research'.format(project)

else:
    custom_var = 'ct_subject_id'
    writeResearchSubjectID( url_local, project, subject_id,custom_var,ct_subject_label)

#logging.debug("Anonymising - Processing crsub:{} ctses:{} proj:{}  subject id: {} session id:{} dt:{} anon_project:{} benchmark:{}".format(ct_subject_label, ct_session_label, project, subject_id, session_id, session_date, anon_project, benchmark))
scan_labels = []


rtstruct_exists=False
assessor_label=""
rtstruct_dicom_file=""
rtstruct_dicom_filename=""



result, errors = parse_anonymised_directory(anon_path)
if not result:
    #TODO: handle errors properly
    logging.error(errors)
    sys.exit(2)
else:
    ##### CREATE SESSION ON ANONYMOUS SITE:
    url = "{}/data/projects/{}/subjects/{}/experiments/{}".format(url_anon,anon_project, ct_subject_label, ct_session_label)
    try:
        session_created = create_anon_session(anon_path,session, url, session_date)
    except Exception as detail:
        logging.error("Failed to create session {} - {} -{} - {} : {}".format(anon_path, session, url, session_date, detail))
        sys.exit(2)
    if not session_created:
        logging.error("Failed to create session for unknow reason {} - {} - {} - {} ".format(anon_path, session, url, session_date ))
        sys.exit(2)
    try:
        ct_subject_id,ct_session_id, xsiType = find_anon_session(ct_subject_label, ct_session_label, url_anon, anon_project)
    except Exception as detail:
        logging.error("Failed to find session {} : {}".format(ct_subject_label, ct_session_label))
        sys.exit(3)
    #delete any existing assessor
    url_delete_assessor =  "{}/data/projects/{}/subjects/{}/experiments/{}/assessors/{}_CT_{}?".format(url_local, project, subject_id, session_id, clinical_trial_id,ct_session_label, clinical_trial_id, ct_session_label)
    r = session_local.put(url_delete_assessor)

    ct_schema_location = schema_location_template.format(nsdict['xnat'], xnat_host, 'xnat') + \
    schema_location_template.format(nsdict['clinicalTrials'], xnat_host, 'clinicalTrials')

    assessor_label = "{}_CT_{}".format(clinical_trial_id,  ct_session_label)
    random_id = '{}'.format(uuid.uuid4())
    assessor_id = '{}_CT_{}'.format(ct_session_label,  random_id[:8])
    assessor_xml_path = "{}/ct_assessor_{}{}.xml".format(cache_path, subject_id,session_id)
    assessorTitleAttributesDict = {
        'ID': assessor_id,
        'label': assessor_label,
        'project': project,
        ns('xsi','schemaLocation'): ct_schema_location
    }
    name="{}_{}".format(clinical_trial_id, ct_session_label)
    E = ElementMaker(namespace=nsdict['clinicalTrials'], nsmap=nsdict)




    anon_url_assessor = ct_session_id+ "/search_element/"  +  xsiType +"/search_field/" + xsiType + ".ID/project/" + anon_project


    assessorXML = E('clinicaltrial', assessorTitleAttributesDict,
        E(ns('xnat', 'date'), dt.date.today().isoformat()),
        E(ns('xnat', 'imageSession_ID'), ct_session_id),
        E('ct_id', clinical_trial_id),
        E('ct_session_id', ct_session_label),
        E('ct_subject_id', ct_subject_label),
        E('name',name),
        E('anon_url',anon_url_assessor)
    )
    #logging.debug('Writing assessor XML to {}'.format(assessor_xml_path))
    with open(assessor_xml_path, 'wb') as f:
        #f.write(xmltostring(assessorXML, pretty_logging.error=True, encoding='UTF-8', xml_declaration=True))
        f.write(xmltostring(assessorXML,  encoding='UTF-8', xml_declaration=True))



    files = {'upload_file': open(assessor_xml_path,'rb')}
    url = "{}/data/archive/projects/{}/subjects/{}/experiments/{}/assessors/{}".format(url_local,project, subject_id, session_id,assessor_label)
    r = session_local.put(url, files=files)
    if r.status_code != 201:
        logging.error("ERROR: cannot create Pseudonymised Session assessor: {} - {}".format(r.status_code, url))
        sys.exit(6)
    #os.remove(assessor_xml_path)




    ### UPLAOD SCANS AND ASSESSORS
    #logging.debug("##### UPLODAING ANNOYMISED SCANS #####")
    for root, dirs, files in os.walk(anon_path):
        #logging.debug("searching through {}".format(root))
        for fl in files:
            if fl.endswith(".dcm"):
                zip_file=True
    
                with open(os.path.join(root,fl), 'rb') as f:
                    dicom = pydicom.dcmread(f, specific_tags=tags.keys())
                    #logging.debug(dicom
                    series_number = dicom[tags['SeriesNumber']].value
                    modality = dicom[tags['Modality']].value
                    scan_label = series_number
                    uid = dicom[tags['SeriesInstanceUID']].value
                    #scan_label = '{}{}'.format(series_number,modality) - just numerical

                    if scan_label not in scan_labels:
                       
                        #logging.debug('###### Scan {} is a new scan - {}   {} ##########'.format(scan_label, modality, os.path.join(root,fl)))
                        scan_labels.append(scan_label)
                    
                        xsiType = '?xsiType=xnat:otherDicomScanData&xnat:otherDicomScanData/type={}'.format(modality)
                        if 'RT' in modality:
                            xsiType = '?xsiType=xnat:otherDicomScanData&xnat:otherDicomScanData/type={}'.format(modality)
                        elif 'CT' in modality:
                            xsiType = "?xsiType=xnat:ctScanData&xnat:ctScanData/type={}".format(modality)
                        if 'MR' in modality:
                            xsiType = "?xsiType=xnat:mrScanData&xnat:mrScanData/type={}".format(modality)
                        if 'PET' in modality:
                            xsiType = "?xsiType=xnat:petScanData&xnat:petScanData/type={}".format(modality)
                        ### add UID
                        xsiType = '{}&xnat:imageScanData/UID={}&xnat:imageScanData/type={}'.format(xsiType, uid, modality)


                        logging.debug("Creating Scan {}".format(scan_label))
                        url = "{}/data/projects/{}/subjects/{}/experiments/{}/scans/{}{}".format(url_anon,anon_project, ct_subject_id, ct_session_label,scan_label,xsiType)
                     
                        r = session.put(url)
                        #&content=T1_RAW ???
                        url = "{}/data/projects/{}/subjects/{}/experiments/{}/scans/{}/resources/DICOM?format=DICOM&content={}_RAW".format(url_anon,anon_project, ct_subject_id, ct_session_label,scan_label, modality)
                        r = session.put(url)
                        ### make a scan zip file
            
                        zf = zip_filename(ct_session_label, scan_label, cache_path)  #{}/{}.zip'.format(anon_path,scan_label)
                        z = zipfile.ZipFile(zf, "w",zipfile.ZIP_DEFLATED)
                        z.close()

                           
                # add to zip file!!!
                if zip_file:
                    zf = zip_filename(ct_session_label, scan_label, cache_path)  #'/data/{}.zip'.format(scan_label) #'{}/{}.zip'.format(anon_path,scan_label)
                    with zipfile.ZipFile(zf,'a') as zip:
                        zip.write(os.path.join(root,fl), fl)


    logging.debug("Uploading scans....")
    # UPLOAD SCANS
    for scan_label in scan_labels:
#        if 'RTSTRUCT' not in scan_label:
        zip_file = zip_filename(ct_session_label, scan_label, cache_path) 
        files = {'upload_file': open(zip_file,'rb')}
        url = "{}/data/archive/projects/{}/subjects/{}/experiments/{}/scans/{}/resources/DICOM/files?file_format=DICOM&extract=true".format(url_anon,anon_project, ct_subject_id, ct_session_label,scan_label)
        r = session.put(url, files=files)
        if r.status_code != 200:
            logging.error("ERROR: cannot upload annoymised scan files: {} - {}".format(scan_label, r.status_code))
            sys.exit(10)

        os.remove(zip_file)
    # Trigger autorun piepline
    url = "{}/data/archive/projects/{}/subjects/{}/experiments/{}?triggerPipelines=true".format(url_anon,anon_project, ct_subject_id, ct_session_label)
    r = session.put(url)
    time.sleep(60)
    if r.status_code != 200:
        logging.error("ERROR: cannot trigger autorun piepline: {} - {}".format(scan_label, r.status_code))
        sys.exit(11)
    logging.debug("removing files")
    shutil.rmtree(cache_path)


    #RT STRUCT ASSESSORS
    logging.info("#########--- Finished exporting session ---###################")
    sys.exit(0)

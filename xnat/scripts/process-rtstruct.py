#!/usr/bin/env python

'''make-rt-struct-assessor.py
Read in an RT-STRUCT DICOM file. Write out an icr:roiCollectionData assessor.

Usage:
    make-rt-struct-assessor.py SESSION_ID SESSION_LABEL PROJECT

Options:
    SESSION_ID                  ID of parent session
    SESSION_LABEL               Label of parent session
    PROJECT                     Project of parent session


'''

import os
import sys
import uuid
import logging
import pydicom
import datetime as dt
import subprocess
import requests
from docopt import docopt
from lxml.builder import ElementMaker
from lxml.etree import tostring as xmltostring


import configparser


date_now = '{0:%Y-%m-%d}'.format(dt.datetime.now())
logfile = '/data/xnat/scripts/logs/process_rtstruct_{}.log'.format(date_now)
logging.basicConfig(filename=logfile,  format='%(name)s - %(levelname)s - %(message)s', level=logging.INFO)

#config = ConfigParser.RawConfigParser()
#config.read('/data/xnat/home/xnat.cfg')
server = 'http://localhost:8080' #config.get('xnat', 'xnat_host')
usr = os.environ['XNAT_ADMIN'] #  config.get('xnat', 'xnat_user')
pwd = os.environ['XNAT_ADMIN_PWD']  # config.get('xnat', 'xnat_pwd')




nsdict = {'xnat':'http://nrg.wustl.edu/xnat',
          'xsi':'http://www.w3.org/2001/XMLSchema-instance',
          'icr':'http://icr.ac.uk/icr'}

xnat_host = os.environ.get('XNAT_HOST', 'http://nrg.wustl.edu')
schema_location_template = "{0} {1}/xapi/schemas/{2}/{2}.xsd "
schema_location = schema_location_template.format(nsdict['xnat'], xnat_host, 'xnat') + \
                  schema_location_template.format(nsdict['icr'], xnat_host, 'roi')

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

session_id = args.get('SESSION_ID')
session_label = args.get('SESSION_LABEL')
project = args.get('PROJECT')




###### RUN AS PIPELINE - CONVERT TO RT STRUCT - CHECKS THAT CONFORMS AS WELL
### go through archive path /data/xnat/archive/arc001/SESSIONLABEL/
### find with RTSTRUCT as modality 0008,0060
### create xml, using this
### upload
### PROBLEM, how to sync to other XNAT!!!! Maybe on other side rerun? Create XML again when sending?
### need to use python to corrcetly create anonymised sesison....using REST to create


## replace these with specifics:
dicom_path = ""
assessor_xml_path = "/data/xnat/cache/temp/{}/roi_assessor_{}.xml".format(session_label, session_label)
roi_labels_path = "/data/xnat/cache/temp/{}/roi_labels_{}.txt".format(session_label, session_label)
rt_num = 1


if os.path.exists(roi_labels_path):
    os.remove(roi_labels_path)
if os.path.exists(assessor_xml_path):
    os.remove(assessor_xml_path)


#create session

url_xnat = 'http://localhost:8080'
session = requests.Session()
session.auth = (usr, pwd)
auth = session.post(url_xnat)



session_path = os.path.join('/data','xnat','archive',project,'arc001',session_label)
roiObservationLabels = []

#### Find the RTSTRUCT file
tags = {
    'SeriesNumber': (0x0020, 0x0011),
    'SOPInstanceUID': (0x0008, 0x0018),
    'StudyDate': (0x0008, 0x0020),
    'StudyTime': (0x0008, 0x0030),
    'Modality': (0x0008, 0x0060),
    'StructureSetROISequence': (0x3006,0x0020),
    'RTROIObservationsSequence': (0x3006,0x0080),
    'StructureSetLabel': (0x3006, 0x0002),
    'ReferencedFrameOfReferenceSequence': (0x3006, 0x0010)
}

logging.info("##### Processing session: {} ########".format(session_path))
#logging.debug("Debug: args " + ", ".join("{}={}".format(name, value) for name, value in args.items()) + "\n")
for root, dirs, files in os.walk(session_path):    
    for file in files:
        if file.endswith(".dcm") and 'ASSESSOR' not in root:
            with open(os.path.join(root,file), 'rb') as f:
                dicom = pydicom.dcmread(f, specific_tags=tags.keys())
                modality = dicom[tags['Modality']].value
                if 'RTSTRUCT' in modality:       
                 
                    dicom_path = os.path.join(root,file)
                    assessor_xml_path =assessor_xml_path.replace(".xml","{}.xml".format(rt_num))
                    rt_num=rt_num+1

                    
                    logging.info("Reading RT-STRUCT DICOM from {}".format(dicom_path))
                    
               

                    series_number = dicom[tags['SeriesNumber']].value
                    uid = dicom[tags['SOPInstanceUID']].value
                    name = dicom[tags['StructureSetLabel']].value
                    date =  dicom[tags['StudyDate']].value if tags['StudyDate'] in dicom else "yyyymmdd"
                    time_header = dicom[tags['StudyTime']].value if tags['StudyTime'] in dicom else "hhmmss"
                    time = time_header if '.' not in time_header else time_header[:time_header.index('.')]


                    ## need to get roi_labels.json from project/resources (or put in scripts?)
                    ## then do comparison, set QC in 
                    # change name of uplaoded file to roil_label_scanid.json
                    pinnacle=False
                    try:
                        for rois in dicom[tags['RTROIObservationsSequence']]:                          
                         
                            #PINNACLE DOES NOT USE 0085 tag, just 26
                            #logging.debug("{}".format(rois))
                            roi_label = rois[(0x3006, 0x0085)].value
                            roiObservationLabels.append(roi_label)
                    except Exception as e:
                        logging.error("Error appending ROI label: {} - is it Pinnacle?".format(e))
                        pinnacle=True

                    if pinnacle:
                        try:
                            for rois in dicom[tags['StructureSetROISequence']]:                          
                             
                                #PINNACLE DOES NOT USE 0085 tag, just 26
                                #logging.debug("{}".format(rois))
                                roi_label = rois[(0x3006, 0x0026)].value
                                roiObservationLabels.append(roi_label)
                        except Exception as e:
                            logging.error("Error appending ROI label: {} - is it Pinnacle?".format(e))

                    #logging.debug('Obervation Labels: {}'.format(roiObservationLabels))
                    #roi_labels_path =roi_labels_path.replace('.','{}.'.format(rt_num))

                    with open(roi_labels_path, 'a+') as f:
                        for lab in roiObservationLabels:
                            label_string='{}'.format(lab)
                            f.write('{}\n'.format(label_string)) #.encode(encoding='utf-8',errors='strict'))
                        #f.write('{}'.format(roiObservationLabels))
                    
                    files = {'upload_file': open(roi_labels_path,'rb')}
                    url = "{}/data/archive/experiments/{}/resources/roi_labels/files/roi_labels.txt".format(url_xnat, session_id)
                    r = session.put(url, files=files)
                    if r.status_code != 200:
                        logging.error("ERROR: Cannot upload ROI labels: {} - {}".format(r.status_code, url))
                        sys.exit(10)
                    
                    assessor_label = "{}_RTSTRUCT_{}{}".format(session_label, date, "_" + time if time != "hhmmss" else "")
                   

                    ### IF greater than 10MB do not do!!!!!!
                    if os.stat(dicom_path).st_size > 10000000:
                        logging.info("RTSTruct file size to great for viewer: {} {}".format(dicom_path, os.stat(dicom_path).st_size))
                    else:
                        headers = {'Content-Type' : 'application/octet-stream'}
                        data = {'upload_file': open(dicom_path,'rb')}
                        url = "{}/xapi/roi/projects/{}/sessions/{}/collections/{}?type=RTSTRUCT&overwrite=true".format(url_xnat, project, session_id, assessor_label)
                        r = session.put(url, headers=headers, data=open(dicom_path,'rb'))
                        if r.status_code == 201 or r.status_code == 200:
                            something=True
                        else:
                            logging.error("ERROR: Cannot upload RTStruct file: {} - {} - {} - {}".format(r.status_code, url,dicom_path, r.text))

                    
                        #Rebuild viewer metadata json - CAUSED SOME DATA TO HANG
                        url = "{}/xapi/viewer/projects/{}/experiments/{}".format(url_xnat,project, session_id)
                        r = session.post(url)
                        if r.status_code != 201:
                            logging.error("ERROR: Cannot rebuild viewer json metadata for : {} - {}".format(r.status_code, url))
                            sys.exit(10)

                   

if rt_num > 1:
    files = {'upload_file': open(roi_labels_path,'rb')}
    url = "{}/data/archive/experiments/{}/resources/roi_labels/files/roi_labels.txt".format( url_xnat, session_id)
    r = session.put(url, files=files)
    if r.status_code != 200:
        logging.error("ERROR: Cannot upload roi_lablels.txt file: {}".format(r.status_code))
        sys.exit(20)

logging.info('Process RT finished')






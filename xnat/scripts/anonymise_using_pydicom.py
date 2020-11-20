#!/usr/bin/env python

'''export-anon-dat.py
Sends anonymised ICR ROI assessors and scans to the anonymised XNAT

Usage:
    anonymise_using_pydicomv2.py CT_ID CT_SUBJECT_ID CT_SESSION_ID ANON_PATH BENCHMARK

Options:
    CT_ID
    CT_SUBJECT_ID
    CT_SESSION_ID
    ANON_PATH
    BENCHMARK


'''

import os
import sys
import uuid
import shutil
import pydicom
import logging
import subprocess
import random
from docopt import docopt
import zipfile
import time
from datetime import date
from datetime import datetime
from datetime import timedelta
from os.path import basename
import tempfile
from pydicom.tag import Tag

version = "1.0"
args = docopt(__doc__, version=version)

#clinical trial subject and session ids
clinical_trial_id = args.get("CT_ID")
clinical_trial_subject_id = args.get("CT_SUBJECT_ID")
clinical_trial_session_id = args.get("CT_SESSION_ID")
anon_path= args.get('ANON_PATH')
benchmark= args.get('BENCHMARK')


date_now = '{0:%Y-%m-%d}'.format(datetime.now())
logfile = '/data/xnat/scripts/logs/anon_using_pydicom_{}.log'.format(date_now)
logging.basicConfig(filename=logfile,  format='%(name)s - %(levelname)s - %(message)s', level=logging.INFO)
#logging.basicConfig(filename=logfile,  format='%(name)s - %(levelname)s - %(message)s', level=logging.DEBUG)

#TO DO - offset dates so relative dates
date_offset = random.randint(1, 1000)

#### Find the RTSTRUCT file
tags = {
    'SeriesNumber': (0x0020, 0x0011),
    'SeriesDescription': (0x0008, 0x103E),
    'SOPInstanceUID': (0x0008, 0x0018),
    'StudyDate': (0x0008, 0x0020),
    'StudyTime': (0x0008, 0x0030),
    'Modality': (0x0008, 0x0060),
    'DeidentificationMethod': (0x0012,0x0063),
    'RTROIObservationsSequence': (0x3006,0x0080),
    'StructureSetLabel': (0x3006, 0x0002),
    'ReferencedFrameOfReferenceSequence': (0x3006, 0x0010)
}


def dicom_to_datetime(dicomDate):
    logging.debug("year: {}  month: {} day: {}".format(dicomDate[:4], dicomDate[4:6], dicomDate[6:]))
    dt = date(int(dicomDate[:4]), int(dicomDate[4:6]), int(dicomDate[6:]))

    return dt


def generate_sop_uid(study_number, series_number, instance_number):
    
    #pydicom.uid.generate_uid(prefix='1.2.826.0.1.3680043.8.498.', entropy_srcs=None) 
    iso = "1"
    ansi_body = "3"
    country = "6"
    body = "1111111"
    device = random.randint(1, 100000)
    device_serial = random.randint(1, 100000)
    date_encoded = random.randint(1000000000,9999999999) #timestamp = datetime.timestamp(datetime.now())
    sop_uid = '{}.{}.{}.{}.{}.{}.{}.{}.{}.{}'.format(iso, ansi_body, country, body, device, device_serial, study_number, series_number, instance_number, date_encoded)
    return sop_uid



def anonymise_uids(anon_out_path, study_number):
    # why exclude?? Why SOP CLASS  0016? - because in metadata as well in media storage 0002 tag? urgh
    # EXCLUDE SOP CLASSES - start with 1.2.840.10008
    #exclude_tags = ['(0008, 1150)' , '(0008, 0016)']
    #exclude_tags = ['(0008, 1150)']

    # 0002 tags are FILE METADATA...including media storage SOP UIDs
    #file_meta = pydicom.dataset.FileMetaDataset()
    MediaStorageSOPClassUID = '1.2.840.10008.5.1.4.1.1.2'
    MediaStorageSOPInstanceUID = "1.2.3"
    ImplementationClassUID = "1.2.3.4"


    replace_uids_dict = {"XXXXXXX":"XXXXXX"}
    series_number = "1000"

    for root, dirs, files in os.walk(anon_out_path):
        for fl in files:
            if fl.endswith(".dcm"):
                with open(os.path.join(root,fl), 'rb') as f:

                            
                    dataset = pydicom.dcmread(f)
                    #file_meta = dataset.file_meta
                    for elem in dataset.iterall():
                        #for ee in exclude_tags:
                        #    print(ee)
                        #if elem.VR == "UI" and '{}'.format(elem.tag) not in exclude_tags:
                        # 1.2.840 are SOP CLass - do not anonymise
                        if elem.VR == "UI" and '1.2.840.10008' not in '{}'.format(elem.value):
                            if elem.value not in replace_uids_dict.keys():
                                logging.debug("NEW UID: {} - {}".format(elem.tag, elem.value))
                                new_uid = generate_sop_uid(study_number, series_number, '200')
                                replace_uids_dict[elem.value] = new_uid
                            else:
                                logging.debug("Existing UID: {} - {}".format(elem.tag, elem.value))
                                new_uid = replace_uids_dict[elem.value]
                            elem.value = new_uid
                    # for some reason media storage SOP UIDs do not copy correctl;y....


                    #new_sopclass_uid = generate_sop_uid(study_number, series_number, '200')
                    #dataset.data_element('MediaStorageSOPClassUID').value  = '{}'.format(new_sopclass_uid)
                    #dataset.data_element('SOPClassUID').value  = new_sopclass_uid
                    #dataset.data_element('MediaStorageSOPInstanceUID').value  = dataset.SOPInstanceUID

                    dataset.data_element('DeidentificationMethod').value = '{}{}'.format(deid, " and pydicom anon")
                    dataset.file_meta.MediaStorageSOPInstanceUID = dataset.SOPInstanceUID
                    dataset.file_meta.MediaStorageSOPClassUID = dataset.SOPClassUID
                    dataset.file_meta.ImplementationClassUID = "1.2.3.4"
                    #logging.debug(dataset.file_meta)
                    #dataset.file_meta = file_meta
                    dataset.save_as(os.path.join(root,fl), write_like_original=True)


study_number = random.randint(1, 100)
anon_out_path =  '{}-anon'.format(anon_path)
if os.path.isdir(anon_out_path):
    shutil.rmtree(anon_out_path)
os.mkdir(anon_out_path)
rt_file_exists=False

time_now = '{0:%H:%M}'.format(datetime.now())
logging.info("############## {}: Anonymise Dicoms using PyDicom: {} #####################".format(time_now, anon_path))
for root, dirs, files in os.walk(anon_path):
    for fl in files:
        #logging.debug(fl)
        if fl.endswith(".dcm"):
            with open(os.path.join(root,fl), 'rb') as f:
                try:
                    #logging.debug("file found: {}".format(fl))
                    dataset = pydicom.dcmread(f)

                    dataset.remove_private_tags()

                    for elem in dataset.iterall():
                        if elem.VR == "DA":

                            newDate = dicom_to_datetime(elem.value) - timedelta(days=date_offset)
                            logging.debug("{} - {} - {}".format(elem, date_offset, newDate.strftime("%Y%m%d")))
                            elem.value = newDate.strftime("%Y%m%d")
                        if elem.VR == "TM":
                            elem.value = '120000.000000'


                    # enter clinical trial info
                    dataset.PatientName = '{}'.format(clinical_trial_subject_id)
                    dataset.data_element('PatientID').value = '{}'.format(clinical_trial_session_id)
                    dataset.data_element('ReferringPhysicianName').value = '{}'.format(clinical_trial_id)


                    if '0' in benchmark:
                        dataset.data_element('ReferringPhysicianName').value = '{}_benchmark'.format(clinical_trial_id)


                    # set STudy ID, as removed from anoanymisation
                    dataset.data_element('StudyID').value = '0'  #? ananoymsiation gets rid of.... dunno if important

                    # Add a note so know it has been anoymised
                    deid=dataset.data_element('DeidentificationMethod').value


                    ## add pydicom to anonymisation description ####
                    #deid= "1" #dataset.data_element('DeidentificationMethod').value
                    #dataset.data_element('DeidentificationMethod').value = '{}{}'.format(deid, " and pydicom anon")
                    output_filename = "{}/{}".format(anon_out_path, fl)#
                    logging.debug("Output filename:",output_filename)
                    dataset.save_as(output_filename)
                except Exception as e:
                    logging.error("Error anonymsiing dicom file: {}".format(e))
                    sys.exit(10)
                

#else:
try:
    anonymise_uids(anon_out_path, study_number)
except Exception as e:
    logging.error("Error annoaymsiing UIDs: {}".format(e))
    sys.exit(10)

sys.exit(0)






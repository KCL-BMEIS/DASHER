#!/usr/bin/env python

'''make-rt-struct-assessor.py
Read in an RT-STRUCT DICOM file. Write out an icr:roiCollectionData assessor.

Usage:
    make-rt-struct-assessor.py PROJECT SUBJECT_ID SESSION_LABEL  NEW_LABELS

Options:
    PROJECT                     Project of parent session
    SUBJECT_ID                  ID of parent subject
    SESSION_LABEL               Label of parent session
    NEW_LABELS                  New ROI labels


'''

import os
import sys
import uuid
import pydicom
import requests
import logging
import datetime as dt
import subprocess
from docopt import docopt

import configparser
#config = ConfigParser.RawConfigParser()
#config.read('/data/xnat/home/xnat.cfg')
server = 'http://localhost:8080' #config.get('xnat', 'xnat_host')
usr = os.environ['XNAT_ADMIN'] #  config.get('xnat', 'xnat_user')
pwd = os.environ['XNAT_ADMIN_PWD']  # config.get('xnat', 'xnat_pwd')

date_now = '{0:%Y-%m-%d}'.format(dt.datetime.now())
logfile = '/data/xnat/scripts/logs/replace_rt_labels_{}.log'.format(date_now)
logging.basicConfig(filename=logfile,  format='%(name)s - %(levelname)s - %(message)s', level=logging.INFO)


def get_dicom_header_value(line):
    left_bracket_idx = line.find('[')
    right_bracket_idx = line.find(']')
    if left_bracket_idx == -1 or right_bracket_idx == -1:
        return None
    return line[left_bracket_idx + 1:right_bracket_idx]

version = "1.0"
args = docopt(__doc__, version=version)

subject_id = args.get("SUBJECT_ID")
session_label = args.get('SESSION_LABEL')
project = args.get('PROJECT')
new_labels_csv = args.get('NEW_LABELS')



#logging.debug "Debug: args " + ", ".join("{}={}".format(name, value) for name, value in args.items()) + "\n"
logging.info("##### Replacing RT Labels for: {} {}".format(subject_id, session_label))

new_labels = new_labels_csv.split(',')

logging.debug(' new labels: {}'.format(new_labels))


dicom_path = ""
roi_labels_path = "/data/xnat/cache/temp/{}/roi_labels_{}.txt".format(session_label, session_label)
if os.path.exists(roi_labels_path ):
    os.remove(roi_labels_path)
rt_num = 1



url = "http://localhost:8080"
session = requests.Session()
session.auth = (usr, pwd)
auth = session.post(url)


session_path = os.path.join('/data','xnat','archive',project,'arc001',session_label)


#### Find the RTSTRUCT file
tags = {
    'SeriesNumber': (0x0020, 0x0011),
    'RTROIObservationsSequence': (0x3006,0x0080),
    'ROIName' :  (0x3006,0x0020),
    'Modality': (0x0008, 0x0060)
}
roiObservationLabels = []
for root, dirs, files in os.walk(session_path):
    #logging.debug("searching through {}".format(root))
    
    for file in files:
        if file.endswith(".dcm"):
            with open(os.path.join(root,file), 'rb') as f:
                ds = pydicom.dcmread(f)
                modality = ds.Modality
                if 'RTSTRUCT' in modality.upper() and 'ASSESSOR' not in root.upper():


                    series_number = 0; #dataset[tags['SeriesNumber']].value
                    # Need to get ROI observation labels to check to see if they conform....upload as csv?                    

                    new_label_num = 0

                    if 'StructureSetROISequence' in ds:
                        try:
                            for roi in ds.StructureSetROISequence:
                                roi_label = roi.ROIName
                                roi.ROIName = new_labels[new_label_num]
                                roiObservationLabels.append(new_labels[new_label_num])
                                new_label_num += 1
                        except Exception as e:
                            logging.error("ERROR: StructureSetROISequence error - {}".format(e) )
                            sys.exit(1)

                    new_labels_list_complete = False
                    if len(roiObservationLabels) == len(new_labels):
                        new_labels_list_complete = True

                    if 'RTROIObservationsSequence'  in ds :
                        try:
                            new_label_num = 0
                            for sequence in ds.RTROIObservationsSequence:
                                if 'ROIObservationLabel' in sequence:
                                    roi_label = sequence.ROIObservationLabel
                                    sequence.ROIObservationLabel = new_labels[new_label_num]
                                    if not new_labels_list_complete:
                                        roiObservationLabels.append(new_labels[new_label_num])
                                    new_label_num += 1
                        except Exception as e:
                            logging.error("ERROR: RTROIObservationsSequence error - {}".format(e) )
                            sys.exit(1)

                    if len(roiObservationLabels) != len(new_labels):
                        logging.error("ERROR: Not all labels found - error - {}".format(roiObservationLabels))
                        sys.exit(1)
                     
                    ds.save_as(os.path.join(root,file), write_like_original=True)
                    logging.info("Writing labels to roi_file: {} - {} ".format(file, roiObservationLabels))

                    with open(roi_labels_path, 'a+') as f:
                        for lab in roiObservationLabels:
                            label_string='{}'.format(lab)
                            f.write('{}\n'.format(label_string)) #.encode(encoding='utf-8',errors='strict'))
                            #f.write('{}\n'.format(lab.replace(" ","")).encode(encoding='utf-8',errors='strict'))                    #f.write('{}'.format(roiObservationLabels))


                    url = "http://localhost:8080/data/archive/projects/{}/subjects/{}/experiments/{}/resources/roi_labels/files/roi_labels.txt?overwrite=true".format(project, subject_id,session_label)
                    files = {'upload_file': open(roi_labels_path, 'rb')}
                    r = session.put(url, files=files)
                    if r.status_code != 201 and r.status_code != 200:
                        logging.error(
                            "ERROR: Cannot upload ROI lables file: {} - {} - {}".format(r.status_code, url,roiObservationLabels))
                        sys.exit(20)


#delete at end as seems to double write...
os.remove(roi_labels_path)
sys.exit(0)
                    
                

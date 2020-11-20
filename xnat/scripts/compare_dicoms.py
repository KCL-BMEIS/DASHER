#!/usr/bin/env python

'''export-anon-dat.py
Sends anonymised ICR ROI assessors and scans to the anonymised XNAT

Usage:
    compare_dicoma.py PROJECT SESSION_LABEL ANON_PATH

Options:
    PROJECT
    SESSION_LABEL
    ANON_PATH

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
from datetime import datetime
from os.path import basename
import tempfile
from pydicom.tag import Tag

version = "1.0"
args = docopt(__doc__, version=version)


project = args.get("PROJECT")
session_label = args.get("SESSION_LABEL")
anon_path = args.get('ANON_PATH')


date_now = '{0:%Y-%m-%d}'.format(datetime.now())
logfile = '/data/xnat/scripts/logs/compare_dicoms_{}.log'.format(date_now)
logging.basicConfig(filename=logfile,  format='%(name)s - %(levelname)s - %(message)s', level=logging.INFO)
#logging.basicConfig(filename=logfile, format='%(name)s - %(levelname)s - %(message)s', level=logging.DEBUG)


def session_dataset(session_label, project):
    session_path = '/data/xnat/archive/{}/arc001/{}/SCANS'.format(project, session_label)
    for root, dirs, files in os.walk(session_path):
        for fl in files:
            #logging.debug(fl)
            if fl.endswith(".dcm"):
                with open(os.path.join(root, fl), 'rb') as f:
                    nonanon_dataset = pydicom.dcmread(f)
                    return nonanon_dataset


tags = {
    'SeriesDescription': (0x0008, 0x103E),
    'PatientName': (0x0010, 0x0010),
    'PatientID': (0x0010, 0x1020),
    'SOPInstanceUID': (0x0008, 0x0018),
    'SeriesInstanceUID': (0x0020, 0x000E),
    'StudyInstanceUID': (0x0020, 0x000D),
    'StudyDate': (0x0008, 0x0020),
    'DeidentificationMethod': (0x0012, 0x0063),
}

session_ds = session_dataset(session_label, project)
tags_compared = 0
logging.info("############## Compare anonymised and Original Dicom datasets: {} #####################".format(anon_path))
for root, dirs, files in os.walk(anon_path):
    for fl in files:
        # logging.debug(fl)
        if fl.endswith(".dcm"):
            with open(os.path.join(root, fl), 'rb') as f:
                logging.debug("file found: {}".format(os.path.join(root, fl)))
                dataset = pydicom.dcmread(f)
                suc = True
                for tag in tags:
                    try:
                        if tag in dataset and  tag in session_ds:
                            tags_compared = tags_compared + 1
                            if dataset.data_element(tag).value == session_ds.data_element(tag).value:
                                logging.info('dataset contains same values {} - {} - {}'.format(tag, dataset.data_element(tag).value, session_ds.data_element(tag).value ))
                                suc = False
                    except Exception as e:
                        logging.info('Could not compare tag {} : {}'.format(tag, e))
                        exit(1)
                if not suc:
                    exit(1)
                else:
                    if tags_compared > 0:
                        logging.info('Sucecessfully anonymised')
                        exit(0)
                    else:
                        logging.error('No tags comapred.... something wrong')
                        exit(1)








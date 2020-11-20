#!/usr/bin/env python

'''make-rt-struct-assessor.py
Read in an RT-STRUCT DICOM file. Write out an icr:roiCollectionData assessor.

Usage:
    print_dicom_header.py FILE

Options:
    FILE                  ID of parent subject


'''

import os
import sys
import logging

import pydicom

import datetime as dt
import subprocess
import requests
from docopt import docopt

version = "1.0"
args = docopt(__doc__, version=version)

file = args.get("FILE")

try:
    with open(file, 'rb') as f:
        dicom = pydicom.dcmread(f)
        print(dicom)

except Exception as e:
    print("ERROR: - {}".format(e))
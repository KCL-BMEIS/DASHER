
#!/usr/bin/env python

'''export-anon-dat.py
Inserts UIDS into catalog files so it works with OHIF Viewer
Might need to rebuild session after

Usage:
    insert_uids.py SESSION_LABEL PROJECT

Options:
    SESSION_LABEL
    PROJECT


'''


import os
import pydicom
from docopt import docopt


version = "1.0"
args = docopt(__doc__, version=version)

project = args.get('PROJECT')
session_label= args.get('SESSION_LABEL')

session_path = "/data/xnat/archive/{}/arc001/{}/".format(project, session_label)

replace_uids_dict = {"XXXXXXX":"XXXXXX"}
instance_numbers = {"XXXX":"XXXXX"}
for root, dirs, files in os.walk(session_path):
    for fl in files:
        #logging.debug(fl)
        if fl.endswith(".dcm"):
            with open(os.path.join(root,fl), 'rb') as f:
                # only scans have instance numbers, else empty
                dataset = pydicom.dcmread(f)
                if 'InstanceNumber' in dataset and 'SOPInstanceUID' in dataset:
                    replace_uids_dict[fl] = dataset.SOPInstanceUID
                    instance_numbers[fl] = dataset.InstanceNumber
                elif 'SOPInstanceUID' in dataset:
                    replace_uids_dict[fl] = dataset.SOPInstanceUID
                    instance_numbers[fl] = 'empty'


#print(replace_uids_dict)
for root, dirs, files in os.walk(session_path):
    for fl in files:
        if fl.endswith(".xml"):
            print(fl)
            catalog_file = open(os.path.join(root,fl), "r")
            new_file_content = ""

            for line in catalog_file:
                stripped_line = line.strip()
                new_line=stripped_line
                if 'UID' not in line and 'entry' in line:
                    for key in replace_uids_dict:
                        #new_line=line
                        filename = key
                        if filename in line:
                            SOPINSTANCEUID = replace_uids_dict[filename]
                            #print("filename {}    uid {}".format(filename, SOPINSTANCEUID))


                            new_line = stripped_line.replace('{}"/>'.format(filename), "{}\" ID=\"null/{}\" UID=\"{}\" instanceNumber=\"{}\" xsi:type=\"cat:dcmEntry\" />".format(filename, filename.replace(".dcm",""), SOPINSTANCEUID, instance_numbers[filename]))
                            if 'empty' in str(instance_numbers[filename]):
                                new_line = stripped_line.replace('{}"/>'.format(filename),  "{}\" ID=\"null/{}\" UID=\"{}\"  xsi:type=\"cat:dcmEntry\" />".format(
                                                                     filename, filename.replace(".dcm", ""), SOPINSTANCEUID
                                                                     ))

                            #print("new line: {}".format(new_line))
                            #new_file_content += new_line + "\n"
                    
                new_file_content += new_line + "\n"
            catalog_file.close()
            writing_file = open(os.path.join(root,fl), "w")
            writing_file.write(new_file_content)
            writing_file.close()



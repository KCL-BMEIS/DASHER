import os
import sys
import time
import datetime
import subprocess
import logging
import shutil
import threading
import pydicom

tags = {
    'SeriesNumber': (0x0020, 0x0011),
    'SeriesDescription': (0x0008, 0x103E),
    'SOPInstanceUID': (0x0008, 0x0018),
    'SeriesInstanceUID': (0x0020, 0x000E),
    'StudyInstanceUID': (0x0020, 0x000D),
    'StudyDate': (0x0008, 0x0020),
    'StudyTime': (0x0008, 0x0030),
    'Modality': (0x0008, 0x0060),
    'DeidentificationMethod': (0x0012,0x0063)
}

    

def get_size(start_path = '.'):
    total_size = 0
    for dirpath, dirnames, filenames in os.walk(start_path):
        for f in filenames:
            fp = os.path.join(dirpath, f)
            total_size += os.path.getsize(fp)
    return total_size


def replace_spaces(dicom_dir):

    # need to move to another directory as cannot remove spaces in windows directories
    for root, dirs, files in os.walk(dicom_dir):
        for folder in dirs:
            if  " " in folder:
                #logging.info(" removing space from {}".format(folder))
                os.rename(os.path.join(root,folder), os.path.join(root,folder).replace(" ",""))

def delete_nondicoms(dicom_dir):

   required_fields = {"StudyInstanceUID",'SeriesInstanceUID'}
   mdals = []
   #tags?

   for root, dirs, files in os.walk(dicom_dir):
       for dr in dirs:  
           full_path=os.path.join(root,dr)
           for file in os.listdir(full_path):   
               if os.path.isfile(os.path.join(full_path,file)):
                   #logging.debug("attempting to read {}".format(file))
                   with open(os.path.join(full_path,file), 'rb') as f:
                       try:
                           #logging.info('Checking file header: {}'.format(file))
                           dataset = pydicom.dcmread(f)
                           if dataset.Modality not in mdals:
                               mdals.append(dataset.Modality)
                           ## check headers
                           if "StudyInstanceUID" not in dataset:
                               dataset.StudyInstanceUID = "1111"
                           if 'SeriesInstanceUID' not in dataset:
                               dataset.SeriesInstanceUID = "1111"
                           if 'PatientName' not in dataset:
                               dataset.PatientName = "unknown"
                           if 'PatientID' not in dataset:
                               dataset.PatientID = "unknown"                           
                           if 'SeriesDescription' not in dataset:
                               dataset.SeriesDescription = "unknown"
                           if 'SeriesDate' not in dataset or len(dataset.SeriesDate) <2:
                               dataset.SeriesDate = "20000101"
                           if 'ContentDate' not in dataset or len(dataset.ContentDate) <2:
                               dataset.ContentDate = "20000101"
                           if 'SeriesTime' not in dataset or len(dataset.SeriesTime) <2:
                               dataset.SeriesTime = "120000.000"
                        
                           if (0x0008,0x0123) in dataset:
                               #logging.info('Found 0123 tag in file... removing')
                               del dataset[(0x0008,0x0123)]
                           if (0x0008,0x0124) in dataset:
                               #logging.info('Found 0124 tag in file... removing')
                               del dataset[(0x0008,0x0124)]
                           if (0x0028,0x0303) in dataset:
                               #logging.info('Found 0303 tag in file... removing')
                               del dataset[(0x0028,0x0303)]
                           #dataset.remove_private_tags()
                       
                           
                           dataset.save_as(os.path.join(full_path,file), write_like_original=True)

                       except Exception as e:
                           logging.error("Error: file not dicom? {} {}".format(f, e))
                           os.remove(os.path.join(full_path, file))
   for md in mdals:
       if 'RTSTRUCT' in md.upper() and len(mdals) < 2:
           logging.error("Error: Contains ONLY RTstruct - not importing - {}".format(mdals))
           for dr in os.listdir(dicom_dir):
               shutil.rmtree(os.path.join(dicom_dir,dr))





def push_and_delete(scan_folders):
    logging.info("Pushing fodlers:{}".format(scan_folders))
    for folder in scan_folders:
        cmd = '/opt/DicomBrowser-1.5.2/bin/DicomRemap  -o dicom://XNAT@127.0.0.1:8105/XNAT "{}"'.format(folder)       
        suc = subprocess.check_call(cmd, shell=True)
        if suc > 0:
            logging.error('DicomBrowser Error Return Code: {} -  {} '.format(suc, folder))
        #else:
            #logging.info("Data Pushed {}".format(folder))
    for folder in scan_folders:
        #logging.info("Deleting data {}".format(folder))
        shutil.rmtree(folder)
    #logging.info('############################')
    time.sleep(60)

def get_scan_folders(dicom_dir):

   ###  list directories.....
   ### study_uids for each folder....
   #for study_uid in stduy_uids:
   # check that scan is ok, upload....    

    scan_folders = []
    study_uids = []
    first_scan = True


    #for root, dirs, files in os.walk(dicom_dir):
        #logging.info(dicom_dir)
    #    logging.info("dirs: {} - {}".format(root, dirs))


    for root, dirs, files in os.walk(dicom_dir): 

        num_subdir = sum(os.path.isdir(os.path.join(dicom_dir,i)) for i in os.listdir(dicom_dir))
        
        if num_subdir < 1:
           #logging.info("No subfolders. Using only present directroy: {}".format(dicom_dir))
           scan_folders.append(dicom_dir)
           return scan_folders    
        for dr in dirs:   
           folder_found = False
           full_path=os.path.join(root,dr)
           #logging.debug("dr:{}   full_path:{}".format(dr, full_path))


           for file in os.listdir(full_path):
               if os.path.isfile(os.path.join(full_path,file)):
                   if file.endswith(".gif") or file.endswith(".xml") or file.endswith(".txt") or file.endswith("jpg"):
                       os.remove(os.path.join(full_path,file))
                   elif not folder_found:
                       with open(os.path.join(full_path,file), 'rb') as f:
                           try:
                               dataset = pydicom.dcmread(f)
                               if 'StudyInstanceUID' in dataset and 'SeriesInstanceUID' in dataset:
                                   UID = dataset[tags['StudyInstanceUID']].value
                                   series_uid = dataset[tags['SeriesInstanceUID']].value
                                   if first_scan:
                                       study_uid = UID
                                       first_scan =False
                                   if UID in study_uid:
                                       #logging.info("Appending  path: {}".format(full_path))
                                       scan_folders.append(full_path)
                                       folder_found = True
                                   else:
                                       logging.info("Scan-folders: {}".format(scan_folders))
                                       #logging.info("New session found :{}".format(root))
                                       return scan_folders
                               else:
                                    logging.error("Error: study instance uid or series uid missing: {}".format(os.path.join(full_path, file)))
                           except Exception as e:
                               logging.error("Error: file not dicom? {} {}".format(f, e))
                               #os.remove(os.path.join(full_path, file))                    
                               #return "error in get_scan_folder"

                                


    logging.info("Scan-folders: {}".format(scan_folders))
    return scan_folders


def set_scan_label(scan_folders):


    new_series_number = 9
    series_numbers = []
    series = []

    series_data = dict()

    for folder in scan_folders:        
        #logging.info("----------------")
        logging.debug("Set-scan-label: Scanning folder: {}".format(folder))
        new_series_number = new_series_number + 1
        first_file=True
        for file in os.listdir(folder):       
            try:
               
                with open(os.path.join(folder,file), 'rb') as f:
                    logging.debug("__________")
                    dataset = pydicom.dcmread(f)
                    UID = dataset[tags['StudyInstanceUID']].value
                    series_uid = dataset[tags['SeriesInstanceUID']].value
                    modality = dataset[tags['Modality']].value
                    
                    series_number = dataset[tags['SeriesNumber']].value if tags['SeriesNumber'] in dataset else new_series_number
                    logging.debug(series_number)

                    if 'one' in '{}'.format(series_number):
                        logging.info("series number present but empty - creating new series number {}".format(new_series_number))
                        series_number = new_series_number
                    series_description = dataset[tags['SeriesDescription']].value if tags['SeriesDescription'] in dataset else modality

                    sn = '{}{}'.format(series_uid, modality)
                    logging.debug("file: {} -  sn:{} - series_number:{}".format(file, sn, series_number))
                    series_number = "{}".format(series_number)
                    if first_file:
                        if series_number == '0':
                            logging.info("Series number is ZERO : {} - {}".format(series_number, modality))
                        if len(series_number)<1:
                            series_number = new_series_number
                            logging.info("Series Number missing from header - using new series number {} - {}".format(series_number, modality)   )
                        series.append(sn)
                        series_numbers.append(series_number)
                        series_data[sn] = series_number
                    

                    elif sn in series:
                        series_number = series_data[sn]
                  

                    if sn not in series and not first_file: 
                        #logging.info("New series : sn:{}  folder:{}".format(sn, folder))
                        
                        
                        if len(series_number)<1:
                            series_number = new_series_number

                        clash=True
                        while clash:
                            if series_number in series_numbers:
                                logging.info("CLASH - series number already exists - {} - new series number required:{}".format(sn, new_series_number))
                                series_number = new_series_number 
                                new_series_number = new_series_number+1
                            else:
                                #logging.info('setting clash to false')
                                clash=False

                        #logging.info("{} -  {} - {}".format(f, sn, series_number))
                        series.append(sn)
                        series_numbers.append(series_number)
                        series_data[sn] = series_number

                    first_file = False


              
                    dataset.SeriesDescription = series_description
                    dataset.SeriesNumber = series_number
                    #dataset[tags['SeriesNumber']].value = series_number                                 
                    dataset.save_as(os.path.join(folder,file), write_like_original=True);
            except Exception as e:
                logging.error('ERROR: Could not read {} - {}'.format(file, e))




import_dir='/data/xnat/import_data/'
date_now = '{0:%Y-%m-%d}'.format(datetime.datetime.now())
logfile = '/data/xnat/scripts/logs/import_{}.log'.format(date_now)
logging.basicConfig(filename='/data/xnat/scripts/logs/import.log', filemode='w', format='%(name)s - %(levelname)s - %(message)s', level=logging.INFO)



while True:
    time.sleep(20)
    for folder in os.listdir(import_dir):
        #logging.info('Found folder: {}'.format(folder))
        static = False
        while not static:
            num_of_files1  = sum([len(files) for r, d, files in os.walk(os.path.join(import_dir,folder))])
            time.sleep(40)
            num_of_files2 = sum([len(files) for r, d, files in os.walk(os.path.join(import_dir,folder))])
            if num_of_files2 < 1:
                shutil.rmtree(os.path.join(import_dir,folder))
            if num_of_files1 == num_of_files2:
               
                logging.info("Folder: {}  num_of_files1: {}   num_of_files2: {} - static, importing".format( folder, num_of_files1,num_of_files2))
                
                temp_dir = "/data/xnat/cache/import"
                if os.path.isdir(temp_dir):
                    shutil.rmtree(temp_dir)
                #logging.info("copying data {} {}".format(dicom_dir, temp_dir))   
                #shutil.copytree( dicom_dir, temp_dir)
                
                scan_folders = get_scan_folders(os.path.join(import_dir,folder))
                scan_num=0
                for scan_folder in scan_folders:
                    #logging.info('Copying {} to {}/{}{}'.format(scan_folder, temp_dir, os.path.basename(scan_folder), scan_num ))
                    shutil.copytree(scan_folder, '{}/{}{}'.format(temp_dir, os.path.basename(scan_folder), scan_num))
                    shutil.rmtree(scan_folder)
                    scan_num=scan_num+1
                try:
                    logging.debug("replacing spaces")
                    replace_spaces(temp_dir)
                    logging.debug("deleting non dicoms")
                    delete_nondicoms(temp_dir)
                except Exception as e:
                    logging.error("{}".format(e))
                folder = folder.replace(" ","")
                static=True
                logging.debug("running scan folders again")
                #redo, in temp dir.
                scan_folders = get_scan_folders(temp_dir)
                logging.debug("ran scan folders again, checking for erros...")
                if "error in get_scan_folder" not in scan_folders:

                    try:
                        set_scan_label(scan_folders)
                        push_and_delete(scan_folders)
                    except Exception as e:
                        logging.error("Error with scan: folder:{}  scan_folders:{}   error:{} - deleting folder".format(folder, scan_folders, e))
                        shutil.rmtree(os.path.join(import_dir,folder))
                        shutil.rmtree(temp_dir)

                for eachArg in sys.argv:   
                    if 'test' in eachArg:
                        logging.info("Test data - exiting")
                        exit()


        
                




/**
 * Modified from the SOPMODel file by Daniel Beasley
 * Original information:
 * web: org.nrg.dcm.id.FixedDicomProjectIdentifier
 * XNAT http://www.xnat.org
 * Copyright (c) 2005-2017, Washington University School of Medicine and Howard Hughes Medical Institute
 * All Rights Reserved
 *
 * Released under the Simplified BSD.
 */

package org.nrg.dcm;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.File;
import java.io.InputStreamReader;
import java.lang.reflect.Field;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;

public final class ROIReader {
	private static final String ROI_FILE = "/data/xnat/scripts/permitted_roi_labels.txt";
	//private static final ImmutableList<String> UPLOADER_CONFIG = getStringsFromResource(CONFIG_FILE);
	//private static final String HOSPITAL_CODE = getProjectFromConfig(CONFIG_FILE);



    private static final Boolean isLabelInList(final String path, final String label) {
        try {
            File initialFile = new java.io.File(path);
            InputStream in = new FileInputStream(initialFile);
            if (null == in) {
                throw new RuntimeException("resource " + ROI_FILE  + " not found");
            }
            IOException ioexception = null;
            try {
                final ImmutableList.Builder<String> builder = ImmutableList.builder();
                final BufferedReader reader = new BufferedReader(new InputStreamReader(in));
                try {
                    
                     for (String line = reader.readLine(); null != line; line = reader.readLine()) {
                        if(line.contains(label)){
                            return true;
                        }
                    }
                    
                } catch (IOException e) {
                    throw ioexception = e;
                } finally {
                    try {
                        reader.close();
                    } catch (IOException e) {
                        throw ioexception = null == ioexception ? e : ioexception;
                    }
                }
            } finally {
                try {
                    in.close();
                } catch (IOException e) {
                    throw null == ioexception ? e : ioexception;
                }
            } 
        } catch (IOException e) {
            throw new RuntimeException("Unable to read resource " + path, e);
        }
        return false;
    }

    /*public static ImmutableList<String> getUploaderConfig() {
        return UPLOADER_CONFIG;
    }*/



   public static Boolean labelMatches(String label) {
        return isLabelInList(ROI_FILE, label);
    }




}
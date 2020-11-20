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

public final class ConfigReader {
	private static final String CONFIG_FILE = "/data/xnat/home/xnat.cfg";
	//private static final ImmutableList<String> UPLOADER_CONFIG = getStringsFromResource(CONFIG_FILE);
	private static final String HOSPITAL_CODE = getProjectFromConfig(CONFIG_FILE);

 	/*private static final ImmutableList<String> getStringsFromResource(final String path) {
        try {
            final InputStream in = SOPModel.class.getResourceAsStream(path);
            if (null == in) {
                throw new RuntimeException("resource " + CONFIG_FILE + " not found");
            }
            IOException ioexception = null;
            try {
                final ImmutableList.Builder<String> builder = ImmutableList.builder();
                final BufferedReader reader = new BufferedReader(new InputStreamReader(in));
                try {
                    for (String line = reader.readLine(); null != line; line = reader.readLine()) {
                        builder.add(line.trim());
                    }
                    return builder.build();
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
    }*/



    private static final String getProjectFromConfig(final String path) {
        try {
            File initialFile = new java.io.File(path);
            InputStream in = new FileInputStream(initialFile);
            if (null == in) {
                throw new RuntimeException("resource " + CONFIG_FILE  + " not found");
            }
            IOException ioexception = null;
            try {
                final ImmutableList.Builder<String> builder = ImmutableList.builder();
                final BufferedReader reader = new BufferedReader(new InputStreamReader(in));
                try {
                    for (String line = reader.readLine(); null != line; line = reader.readLine()) {
                        if (line.contains("hospital_code")){
                        	String hospital_code = line.replace("hospital_code=","").replace(" ","");
                        	return hospital_code;
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
        return "error2";
    }

    /*public static ImmutableList<String> getUploaderConfig() {
        return UPLOADER_CONFIG;
    }*/

   public static String getProject() {
        return HOSPITAL_CODE;
    }





}
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

package org.nrg.xnat.plugins.clinicaltrials.utils;

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

public final class ProtocolReader {
	private static final String PROTOCOL_FILE = "/data/xnat/scripts/protocol.txt";
	private static final ImmutableList<String> PROTOCOLS = getStringsFromResource(PROTOCOL_FILE);
	private static final String TRIAL_NAMES = getTrialNamesFromProtocol(PROTOCOL_FILE);

 	private static final ImmutableList<String> getStringsFromResource(final String path) {
        try {
            File initialFile = new java.io.File(path);
            InputStream in = new FileInputStream(initialFile);
            if (null == in) {
                throw new RuntimeException("resource " + PROTOCOL_FILE  + " not found");
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
    }



    private static final String getTrialNamesFromProtocol(final String path) {
        try {
            File initialFile = new java.io.File(path);
            InputStream in = new FileInputStream(initialFile);
            if (null == in) {
                throw new RuntimeException("resource " + PROTOCOL_FILE  + " not found");
            }
            IOException ioexception = null;
            try {
                final ImmutableList.Builder<String> builder = ImmutableList.builder();
                final BufferedReader reader = new BufferedReader(new InputStreamReader(in));
                try {
                    for (String line = reader.readLine(); null != line; line = reader.readLine()) {
                        if (line.contains("clinical_trial_names")){
                        	String trial_names = line.replace("clinical_trial_names","").replace(" ","");
                        	return trial_names;
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

    public static ImmutableList<String> getProtocolList() {
        return PROTOCOLS;
    }

   public static String getClinicalTrialNames() {
        return TRIAL_NAMES;
    }





}
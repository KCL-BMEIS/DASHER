/*
 * xnat-workshop: org.apache.turbine.app.xnat.modules.screens.XDATScreen_edit_workshop_biosampleCollection
 * XNAT http://www.xnat.org
 * Copyright (c) 2017, Washington University School of Medicine
 * All Rights Reserved
 *
 * Released under the Simplified BSD.
 */

package org.apache.turbine.app.xnat.modules.screens;
import org.apache.commons.lang3.StringUtils;

import org.apache.turbine.util.RunData;
import org.apache.velocity.context.Context;
import org.nrg.xdat.turbine.utils.TurbineUtils;
import org.nrg.xnat.turbine.utils.XNATUtils;
import org.nrg.xdat.XDAT;
import org.nrg.xdat.om.*;
import org.nrg.xdat.om.ClinicaltrialsClinicaltrial;
import org.nrg.xdat.om.XnatExperimentdata;
import org.nrg.xdat.om.XnatImagesessiondata;
import org.nrg.xdat.om.XnatProjectdata;

import org.nrg.xdat.turbine.modules.screens.SecureReport;
import org.nrg.xft.ItemI;
import org.nrg.xft.XFTItem;
import org.nrg.xft.exception.ElementNotFoundException;
import org.nrg.xft.exception.FieldNotFoundException;
import org.nrg.xft.exception.XFTInitException;
import org.nrg.xft.schema.Wrappers.GenericWrapper.GenericWrapperElement;

import org.nrg.xft.security.UserI;
import org.nrg.xnat.turbine.utils.XNATUtils;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Hashtable;
import java.util.List;

public class XDATScreen_edit_clinicalTrials_clinicaltrial extends org.nrg.xdat.turbine.modules.screens.EditScreenA {
	static org.apache.log4j.Logger logger = org.apache.log4j.Logger.getLogger(XDATScreen_edit_clinicalTrials_clinicaltrial.class);
	/* (non-Javadoc)
	 * @see org.nrg.xdat.turbine.modules.screens.EditScreenA#getElementName()
	 */
	public String getElementName() {
	    return "Phase2Day2:radread";
	}
	
public ItemI getEmptyItem(RunData data) throws Exception
	{
		final UserI user = TurbineUtils.getUser(data);
		final ClinicaltrialsClinicaltrial radRead = new ClinicaltrialsClinicaltrial(XFTItem.NewItem(getElementName(), user));
		final String search_element = TurbineUtils.GetSearchElement(data);
		if (!StringUtils.isEmpty(search_element)) {
			final GenericWrapperElement se = GenericWrapperElement.GetElement(search_element);
			if (se.instanceOf(XnatImagesessiondata.SCHEMA_ELEMENT_NAME)) {
				final String search_value = ((String)org.nrg.xdat.turbine.utils.TurbineUtils.GetPassedParameter("search_value",data));
				if (!StringUtils.isEmpty(search_value)) {
					XnatImagesessiondata imageSession = new XnatImagesessiondata(TurbineUtils.GetItemBySearch(data));

					radRead.setImagesessionId(search_value);
					radRead.setId(XnatExperimentdata.CreateNewID());
                    SimpleDateFormat sdf = new SimpleDateFormat("ddMMyyyy");
                    long timestamp=Calendar.getInstance().getTimeInMillis();
					radRead.setLabel(imageSession.getLabel() + "_clinicaltrial_"+ sdf.format(timestamp));
					radRead.setProject(imageSession.getProject());

				}
			}
		}

		return radRead.getItem();
	}

    public void finalProcessing(RunData data, Context context) {        
            
        try {
            
            XnatProjectdata proj=null;
            UserI user = TurbineUtils.getUser(data);
           
            org.nrg.xdat.om.ClinicaltrialsClinicaltrial om = new org.nrg.xdat.om.ClinicaltrialsClinicaltrial(item);
            org.nrg.xdat.om.XnatImagesessiondata mr = om.getImageSessionData();
            context.put("om",om);   

            System.out.println("Loaded om object (org.nrg.xdat.om.ClinicaltrialsClinicaltrial) as context parameter 'om'.");
            context.put("mr",mr);
            System.out.println("Loaded mr session object (org.nrg.xdat.om.XnatImagesessiondata) as context parameter 'mr'.");
            context.put("subject",mr.getSubjectData());
            System.out.println("Loaded subject object (org.nrg.xdat.om.XnatSubjectdata) as context parameter 'subject'.");            
            
            SimpleDateFormat sdf = new SimpleDateFormat("ddMMyyyy");
            long timestamp=Calendar.getInstance().getTimeInMillis();
            context.put("timestamp", timestamp);
            
            
            if (item.getProperty("date")==null){
                item.setProperty("date", Calendar.getInstance().getTime());
            }
             proj=mr.getPrimaryProject(false);
             if(data.getParameters().getString("project")!=null){
                 	proj=XnatProjectdata.getXnatProjectdatasById(data.getParameters().getString("project"), user, false);
             }
            
            if(om.getId()==null){
            	String s = mr.getIdentifier(proj.getId());
            	om.setId(mr.getId() + "_clinicaltrial_" + sdf.format(timestamp));
            	om.setLabel(s + "_clinicaltrial_" + sdf.format(timestamp));
            	om.setProject(proj.getId());
            }
        } catch (Exception e) {
            
         
        }
    }
}

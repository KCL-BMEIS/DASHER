/*
 * xnat-template: org.nrg.xnat.plugins.template.plugin.XnatTemplatePlugin
 * XNAT http://www.xnat.org
 * Copyright (c) 2017, Washington University School of Medicine
 * All Rights Reserved
 *
 * Released under the Simplified BSD.
 */

package org.nrg.xnat.plugins.clinicaltrials.plugin;

import org.nrg.dcm.id.CompositeDicomObjectIdentifier;
import org.nrg.dcm.id.FixedProjectSubjectDicomObjectIdentifier;
import org.nrg.framework.annotations.XnatDataModel;
import org.nrg.framework.annotations.XnatPlugin;
import org.nrg.xdat.bean.ClinicaltrialsClinicaltrialBean;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.jdbc.core.JdbcTemplate;

@XnatPlugin(value = "clinicaltrialsPlugin", 
    name = "XNAT 1.7 clinicalTrials Plugin", 
    entityPackages = "org.nrg.xnat.plugins.clinicaltrials.entities",
        dataModels = {
            @XnatDataModel(value = ClinicaltrialsClinicaltrialBean.SCHEMA_ELEMENT_NAME, singular = "Pseudonymised Session Report", plural = "Pseudonymised Sessions")
        })
@ComponentScan({"org.nrg.xnat.plugins.clinicaltrials.preferences",
                "org.nrg.xnat.plugins.clinicaltrials.repositories",
                "org.nrg.xnat.plugins.clinicaltrials.rest",
                "org.nrg.xnat.plugins.clinicaltrials.utils",
                "org.nrg.xnat.plugins.clinicaltrials.services.impl"})
public class XnatclinicalTrialsPlugin {
    public XnatclinicalTrialsPlugin() {
        _log.info("Creating the XnatclinicalTrialsPlugin configuration class");
    }


    @Bean
    public String clinicaltrialsPluginMessage() {
        return "The Clinical Trials plugin for the secure XNAT data uploader.";
    }

    private static final Logger _log = LoggerFactory.getLogger(XnatclinicalTrialsPlugin.class);
}

/*
 * xnat-template: org.nrg.xnat.plugins.template.preferences.TemplatePreferencesBean
 * XNAT http://www.xnat.org
 * Copyright (c) 2017, Washington University School of Medicine
 * All Rights Reserved
 *
 * Released under the Simplified BSD.
 */

package org.nrg.xnat.plugins.clinicaltrials.preferences;

import org.nrg.framework.configuration.ConfigPaths;
import org.nrg.prefs.annotations.NrgPreference;
import org.nrg.prefs.annotations.NrgPreferenceBean;
import org.nrg.prefs.beans.AbstractPreferenceBean;
import org.nrg.prefs.exceptions.InvalidPreferenceName;
import org.nrg.prefs.services.NrgPreferenceService;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

@NrgPreferenceBean(toolId = "template", toolName = "XNAT 1.7 Template Plugin")
public class clinicalTrialsPreferencesBean extends AbstractPreferenceBean {
    @Autowired
    public clinicalTrialsPreferencesBean(final NrgPreferenceService preferenceService, final ConfigPaths configFolderPaths) {
        super(preferenceService, configFolderPaths);
    }

    @NrgPreference(defaultValue = "['Standard']")
    public List<String> getTemplateNames() {
        return getListValue("templateNames");
    }

    public void setTemplateNames(final List<String> templateNames) {
        try {
            setListValue("templateNames", templateNames);
        } catch (InvalidPreferenceName invalidPreferenceName) {
            //
        }
    }

    @NrgPreference(defaultValue = "['standard']")
    public List<String> getTemplateTypes() {
        return getListValue("templateTypes");
    }

    public void setTemplateTypes(final List<String> templateTypes) {
        try {
            setListValue("templateTypes", templateTypes);
        } catch (InvalidPreferenceName invalidPreferenceName) {
            //
        }
    }
}

/*
 * xnat-template: org.nrg.xnat.plugins.template.services.impl.HibernateTemplateService
 * XNAT http://www.xnat.org
 * Copyright (c) 2017, Washington University School of Medicine
 * All Rights Reserved
 *
 * Released under the Simplified BSD.
 */

package org.nrg.xnat.plugins.clinicaltrials.services.impl;

import org.nrg.framework.orm.hibernate.AbstractHibernateEntityService;
import org.nrg.xnat.plugins.clinicaltrials.entities.clinicalTrials;
import org.nrg.xnat.plugins.clinicaltrials.repositories.clinicalTrialsRepository;
import org.nrg.xnat.plugins.clinicaltrials.services.clinicalTrialsService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Manages {@link clinicalTrials} data objects in Hibernate.
 */
@Service
public class HibernateclinicalTrialsService extends AbstractHibernateEntityService<clinicalTrials, clinicalTrialsRepository> implements clinicalTrialsService {
    /**
     * {@inheritDoc}
     */
    @Transactional
    @Override
    public clinicalTrials findByTemplateId(final String templateId) {
        return getDao().findByUniqueProperty("templateId", templateId);
    }
}

/*
 * xnat-template: org.nrg.xnat.plugins.template.repositories.TemplateRepository
 * XNAT http://www.xnat.org
 * Copyright (c) 2017, Washington University School of Medicine
 * All Rights Reserved
 *
 * Released under the Simplified BSD.
 */

package org.nrg.xnat.plugins.clinicaltrials.repositories;

import org.nrg.framework.orm.hibernate.AbstractHibernateDAO;
import org.nrg.xnat.plugins.clinicaltrials.entities.clinicalTrials;
import org.springframework.stereotype.Repository;

@Repository
public class clinicalTrialsRepository extends AbstractHibernateDAO<clinicalTrials> {
}

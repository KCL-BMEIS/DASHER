/*
 * xnat-template: org.nrg.xnat.plugins.template.entities.Template
 * XNAT http://www.xnat.org
 * Copyright (c) 2017, Washington University School of Medicine
 * All Rights Reserved
 *
 * Released under the Simplified BSD.
 */

package org.nrg.xnat.plugins.clinicaltrials.entities;

import org.nrg.framework.orm.hibernate.AbstractHibernateEntity;

import javax.persistence.Entity;
import javax.persistence.Table;
import javax.persistence.UniqueConstraint;

@Entity
@Table(uniqueConstraints = @UniqueConstraint(columnNames = "templateId"))
public class clinicalTrials extends AbstractHibernateEntity {
    public String getTemplateId() {
        return _templateId;
    }

    public void setTemplateId(final String templateId) {
        _templateId = templateId;
    }

    private String _templateId;
}

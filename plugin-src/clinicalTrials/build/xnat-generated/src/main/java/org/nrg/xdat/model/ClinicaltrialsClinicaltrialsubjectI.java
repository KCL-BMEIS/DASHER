/*
 * GENERATED FILE
 * Created on Thu Feb 20 15:54:22 GMT 2020
 *
 */
package org.nrg.xdat.model;

import java.util.List;

/**
 * @author XDAT
 *
 */
public interface ClinicaltrialsClinicaltrialsubjectI extends XnatSubjectassessordataI {

	public String getXSIType();

	public void toXML(java.io.Writer writer) throws java.lang.Exception;

	/**
	 * @return Returns the research_subject_id.
	 */
	public String getResearchSubjectId();

	/**
	 * Sets the value for research_subject_id.
	 * @param v Value to Set.
	 */
	public void setResearchSubjectId(String v);

	/**
	 * @return Returns the ct_subject_id.
	 */
	public String getCtSubjectId();

	/**
	 * Sets the value for ct_subject_id.
	 * @param v Value to Set.
	 */
	public void setCtSubjectId(String v);
}

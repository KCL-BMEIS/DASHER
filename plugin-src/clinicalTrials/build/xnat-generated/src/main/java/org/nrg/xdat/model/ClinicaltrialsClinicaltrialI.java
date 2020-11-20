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
public interface ClinicaltrialsClinicaltrialI extends XnatImageassessordataI {

	public String getXSIType();

	public void toXML(java.io.Writer writer) throws java.lang.Exception;

	/**
	 * @return Returns the ct_id.
	 */
	public String getCtId();

	/**
	 * Sets the value for ct_id.
	 * @param v Value to Set.
	 */
	public void setCtId(String v);

	/**
	 * @return Returns the ct_subject_id.
	 */
	public String getCtSubjectId();

	/**
	 * Sets the value for ct_subject_id.
	 * @param v Value to Set.
	 */
	public void setCtSubjectId(String v);

	/**
	 * @return Returns the ct_session_id.
	 */
	public String getCtSessionId();

	/**
	 * Sets the value for ct_session_id.
	 * @param v Value to Set.
	 */
	public void setCtSessionId(String v);

	/**
	 * @return Returns the anon_url.
	 */
	public String getAnonUrl();

	/**
	 * Sets the value for anon_url.
	 * @param v Value to Set.
	 */
	public void setAnonUrl(String v);

	/**
	 * @return Returns the name.
	 */
	public String getName();

	/**
	 * Sets the value for name.
	 * @param v Value to Set.
	 */
	public void setName(String v);

	/**
	 * @return Returns the labels_correct.
	 */
	public String getLabelsCorrect();

	/**
	 * Sets the value for labels_correct.
	 * @param v Value to Set.
	 */
	public void setLabelsCorrect(String v);
}

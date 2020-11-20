/*
 * GENERATED FILE
 * Created on Thu Feb 20 15:54:22 GMT 2020
 *
 */
package org.nrg.xdat.om.base.auto;
import org.apache.log4j.Logger;
import org.nrg.xft.*;
import org.nrg.xft.security.UserI;
import org.nrg.xdat.om.*;
import org.nrg.xft.utils.ResourceFile;
import org.nrg.xft.exception.*;

import java.util.*;

/**
 * @author XDAT
 *
 *//*
 ******************************** 
 * DO NOT MODIFY THIS FILE
 *
 ********************************/
@SuppressWarnings({"unchecked","rawtypes"})
public abstract class AutoClinicaltrialsClinicaltrialsubject extends XnatSubjectassessordata implements org.nrg.xdat.model.ClinicaltrialsClinicaltrialsubjectI {
	public static final Logger logger = Logger.getLogger(AutoClinicaltrialsClinicaltrialsubject.class);
	public static final String SCHEMA_ELEMENT_NAME="clinicalTrials:clinicaltrialsubject";

	public AutoClinicaltrialsClinicaltrialsubject(ItemI item)
	{
		super(item);
	}

	public AutoClinicaltrialsClinicaltrialsubject(UserI user)
	{
		super(user);
	}

	/*
	 * @deprecated Use AutoClinicaltrialsClinicaltrialsubject(UserI user)
	 **/
	public AutoClinicaltrialsClinicaltrialsubject(){}

	public AutoClinicaltrialsClinicaltrialsubject(Hashtable properties,UserI user)
	{
		super(properties,user);
	}

	public String getSchemaElementName(){
		return "clinicalTrials:clinicaltrialsubject";
	}
	 private org.nrg.xdat.om.XnatSubjectassessordata _Subjectassessordata =null;

	/**
	 * subjectAssessorData
	 * @return org.nrg.xdat.om.XnatSubjectassessordata
	 */
	public org.nrg.xdat.om.XnatSubjectassessordata getSubjectassessordata() {
		try{
			if (_Subjectassessordata==null){
				_Subjectassessordata=((XnatSubjectassessordata)org.nrg.xdat.base.BaseElement.GetGeneratedItem((XFTItem)getProperty("subjectAssessorData")));
				return _Subjectassessordata;
			}else {
				return _Subjectassessordata;
			}
		} catch (Exception e1) {return null;}
	}

	/**
	 * Sets the value for subjectAssessorData.
	 * @param v Value to Set.
	 */
	public void setSubjectassessordata(ItemI v) throws Exception{
		_Subjectassessordata =null;
		try{
			if (v instanceof XFTItem)
			{
				getItem().setChild(SCHEMA_ELEMENT_NAME + "/subjectAssessorData",v,true);
			}else{
				getItem().setChild(SCHEMA_ELEMENT_NAME + "/subjectAssessorData",v.getItem(),true);
			}
		} catch (Exception e1) {logger.error(e1);throw e1;}
	}

	/**
	 * subjectAssessorData
	 * set org.nrg.xdat.model.XnatSubjectassessordataI
	 */
	public <A extends org.nrg.xdat.model.XnatSubjectassessordataI> void setSubjectassessordata(A item) throws Exception{
	setSubjectassessordata((ItemI)item);
	}

	/**
	 * Removes the subjectAssessorData.
	 * */
	public void removeSubjectassessordata() {
		_Subjectassessordata =null;
		try{
			getItem().removeChild(SCHEMA_ELEMENT_NAME + "/subjectAssessorData",0);
		} catch (FieldNotFoundException e1) {logger.error(e1);}
		catch (java.lang.IndexOutOfBoundsException e1) {logger.error(e1);}
	}

	//FIELD

	private String _ResearchSubjectId=null;

	/**
	 * @return Returns the research_subject_id.
	 */
	public String getResearchSubjectId(){
		try{
			if (_ResearchSubjectId==null){
				_ResearchSubjectId=getStringProperty("research_subject_id");
				return _ResearchSubjectId;
			}else {
				return _ResearchSubjectId;
			}
		} catch (Exception e1) {logger.error(e1);return null;}
	}

	/**
	 * Sets the value for research_subject_id.
	 * @param v Value to Set.
	 */
	public void setResearchSubjectId(String v){
		try{
		setProperty(SCHEMA_ELEMENT_NAME + "/research_subject_id",v);
		_ResearchSubjectId=null;
		} catch (Exception e1) {logger.error(e1);}
	}

	//FIELD

	private String _CtSubjectId=null;

	/**
	 * @return Returns the ct_subject_id.
	 */
	public String getCtSubjectId(){
		try{
			if (_CtSubjectId==null){
				_CtSubjectId=getStringProperty("ct_subject_id");
				return _CtSubjectId;
			}else {
				return _CtSubjectId;
			}
		} catch (Exception e1) {logger.error(e1);return null;}
	}

	/**
	 * Sets the value for ct_subject_id.
	 * @param v Value to Set.
	 */
	public void setCtSubjectId(String v){
		try{
		setProperty(SCHEMA_ELEMENT_NAME + "/ct_subject_id",v);
		_CtSubjectId=null;
		} catch (Exception e1) {logger.error(e1);}
	}

	public static ArrayList<org.nrg.xdat.om.ClinicaltrialsClinicaltrialsubject> getAllClinicaltrialsClinicaltrialsubjects(org.nrg.xft.security.UserI user,boolean preLoad)
	{
		ArrayList<org.nrg.xdat.om.ClinicaltrialsClinicaltrialsubject> al = new ArrayList<org.nrg.xdat.om.ClinicaltrialsClinicaltrialsubject>();

		try{
			org.nrg.xft.collections.ItemCollection items = org.nrg.xft.search.ItemSearch.GetAllItems(SCHEMA_ELEMENT_NAME,user,preLoad);
			al = org.nrg.xdat.base.BaseElement.WrapItems(items.getItems());
		} catch (Exception e) {
			logger.error("",e);
		}

		al.trimToSize();
		return al;
	}

	public static ArrayList<org.nrg.xdat.om.ClinicaltrialsClinicaltrialsubject> getClinicaltrialsClinicaltrialsubjectsByField(String xmlPath, Object value, org.nrg.xft.security.UserI user,boolean preLoad)
	{
		ArrayList<org.nrg.xdat.om.ClinicaltrialsClinicaltrialsubject> al = new ArrayList<org.nrg.xdat.om.ClinicaltrialsClinicaltrialsubject>();
		try {
			org.nrg.xft.collections.ItemCollection items = org.nrg.xft.search.ItemSearch.GetItems(xmlPath,value,user,preLoad);
			al = org.nrg.xdat.base.BaseElement.WrapItems(items.getItems());
		} catch (Exception e) {
			logger.error("",e);
		}

		al.trimToSize();
		return al;
	}

	public static ArrayList<org.nrg.xdat.om.ClinicaltrialsClinicaltrialsubject> getClinicaltrialsClinicaltrialsubjectsByField(org.nrg.xft.search.CriteriaCollection criteria, org.nrg.xft.security.UserI user,boolean preLoad)
	{
		ArrayList<org.nrg.xdat.om.ClinicaltrialsClinicaltrialsubject> al = new ArrayList<org.nrg.xdat.om.ClinicaltrialsClinicaltrialsubject>();
		try {
			org.nrg.xft.collections.ItemCollection items = org.nrg.xft.search.ItemSearch.GetItems(criteria,user,preLoad);
			al = org.nrg.xdat.base.BaseElement.WrapItems(items.getItems());
		} catch (Exception e) {
			logger.error("",e);
		}

		al.trimToSize();
		return al;
	}

	public static ClinicaltrialsClinicaltrialsubject getClinicaltrialsClinicaltrialsubjectsById(Object value, org.nrg.xft.security.UserI user,boolean preLoad)
	{
		try {
			org.nrg.xft.collections.ItemCollection items = org.nrg.xft.search.ItemSearch.GetItems("clinicalTrials:clinicaltrialsubject/id",value,user,preLoad);
			ItemI match = items.getFirst();
			if (match!=null)
				return (ClinicaltrialsClinicaltrialsubject) org.nrg.xdat.base.BaseElement.GetGeneratedItem(match);
			else
				 return null;
		} catch (IllegalAccessException e) {
			final StackTraceElement[] stacktrace = e.getStackTrace();
			final String location = stacktrace == null || stacktrace.length == 0 ? "Unknown (no stack trace)" : stacktrace[0].toString();
			logger.error("The user " + user.getUsername() + " was denied access to the clinicalTrials:clinicaltrialsubject/id instance with ID " + value + ". Occurred at: " + location + "\n" + e.getMessage());
		} catch (Exception e) {
			logger.error("",e);
		}

		return null;
	}

	public static ArrayList wrapItems(ArrayList items)
	{
		ArrayList al = new ArrayList();
		al = org.nrg.xdat.base.BaseElement.WrapItems(items);
		al.trimToSize();
		return al;
	}

	public static ArrayList wrapItems(org.nrg.xft.collections.ItemCollection items)
	{
		return wrapItems(items.getItems());
	}

	public org.w3c.dom.Document toJoinedXML() throws Exception
	{
		ArrayList al = new ArrayList();
		al.add(this.getItem());
		al.add(org.nrg.xft.search.ItemSearch.GetItem("xnat:subjectData.ID",this.getItem().getProperty("xnat:mrSessionData.subject_ID"),getItem().getUser(),false));
		al.trimToSize();
		return org.nrg.xft.schema.Wrappers.XMLWrapper.XMLWriter.ItemListToDOM(al);
	}
	public ArrayList<ResourceFile> getFileResources(String rootPath, boolean preventLoop){
ArrayList<ResourceFile> _return = new ArrayList<ResourceFile>();
	 boolean localLoop = preventLoop;
	        localLoop = preventLoop;
	
	        //subjectAssessorData
	        XnatSubjectassessordata childSubjectassessordata = (XnatSubjectassessordata)this.getSubjectassessordata();
	            if (childSubjectassessordata!=null){
	              for(ResourceFile rf: ((XnatSubjectassessordata)childSubjectassessordata).getFileResources(rootPath, localLoop)) {
	                 rf.setXpath("subjectAssessorData[" + ((XnatSubjectassessordata)childSubjectassessordata).getItem().getPKString() + "]/" + rf.getXpath());
	                 rf.setXdatPath("subjectAssessorData/" + ((XnatSubjectassessordata)childSubjectassessordata).getItem().getPKString() + "/" + rf.getXpath());
	                 _return.add(rf);
	              }
	            }
	
	        localLoop = preventLoop;
	
	return _return;
}
}

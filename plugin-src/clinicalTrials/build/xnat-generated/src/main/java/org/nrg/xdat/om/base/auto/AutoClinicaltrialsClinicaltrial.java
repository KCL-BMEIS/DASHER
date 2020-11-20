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
public abstract class AutoClinicaltrialsClinicaltrial extends XnatImageassessordata implements org.nrg.xdat.model.ClinicaltrialsClinicaltrialI {
	public static final Logger logger = Logger.getLogger(AutoClinicaltrialsClinicaltrial.class);
	public static final String SCHEMA_ELEMENT_NAME="clinicalTrials:clinicaltrial";

	public AutoClinicaltrialsClinicaltrial(ItemI item)
	{
		super(item);
	}

	public AutoClinicaltrialsClinicaltrial(UserI user)
	{
		super(user);
	}

	/*
	 * @deprecated Use AutoClinicaltrialsClinicaltrial(UserI user)
	 **/
	public AutoClinicaltrialsClinicaltrial(){}

	public AutoClinicaltrialsClinicaltrial(Hashtable properties,UserI user)
	{
		super(properties,user);
	}

	public String getSchemaElementName(){
		return "clinicalTrials:clinicaltrial";
	}
	 private org.nrg.xdat.om.XnatImageassessordata _Imageassessordata =null;

	/**
	 * imageAssessorData
	 * @return org.nrg.xdat.om.XnatImageassessordata
	 */
	public org.nrg.xdat.om.XnatImageassessordata getImageassessordata() {
		try{
			if (_Imageassessordata==null){
				_Imageassessordata=((XnatImageassessordata)org.nrg.xdat.base.BaseElement.GetGeneratedItem((XFTItem)getProperty("imageAssessorData")));
				return _Imageassessordata;
			}else {
				return _Imageassessordata;
			}
		} catch (Exception e1) {return null;}
	}

	/**
	 * Sets the value for imageAssessorData.
	 * @param v Value to Set.
	 */
	public void setImageassessordata(ItemI v) throws Exception{
		_Imageassessordata =null;
		try{
			if (v instanceof XFTItem)
			{
				getItem().setChild(SCHEMA_ELEMENT_NAME + "/imageAssessorData",v,true);
			}else{
				getItem().setChild(SCHEMA_ELEMENT_NAME + "/imageAssessorData",v.getItem(),true);
			}
		} catch (Exception e1) {logger.error(e1);throw e1;}
	}

	/**
	 * imageAssessorData
	 * set org.nrg.xdat.model.XnatImageassessordataI
	 */
	public <A extends org.nrg.xdat.model.XnatImageassessordataI> void setImageassessordata(A item) throws Exception{
	setImageassessordata((ItemI)item);
	}

	/**
	 * Removes the imageAssessorData.
	 * */
	public void removeImageassessordata() {
		_Imageassessordata =null;
		try{
			getItem().removeChild(SCHEMA_ELEMENT_NAME + "/imageAssessorData",0);
		} catch (FieldNotFoundException e1) {logger.error(e1);}
		catch (java.lang.IndexOutOfBoundsException e1) {logger.error(e1);}
	}

	//FIELD

	private String _CtId=null;

	/**
	 * @return Returns the ct_id.
	 */
	public String getCtId(){
		try{
			if (_CtId==null){
				_CtId=getStringProperty("ct_id");
				return _CtId;
			}else {
				return _CtId;
			}
		} catch (Exception e1) {logger.error(e1);return null;}
	}

	/**
	 * Sets the value for ct_id.
	 * @param v Value to Set.
	 */
	public void setCtId(String v){
		try{
		setProperty(SCHEMA_ELEMENT_NAME + "/ct_id",v);
		_CtId=null;
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

	//FIELD

	private String _CtSessionId=null;

	/**
	 * @return Returns the ct_session_id.
	 */
	public String getCtSessionId(){
		try{
			if (_CtSessionId==null){
				_CtSessionId=getStringProperty("ct_session_id");
				return _CtSessionId;
			}else {
				return _CtSessionId;
			}
		} catch (Exception e1) {logger.error(e1);return null;}
	}

	/**
	 * Sets the value for ct_session_id.
	 * @param v Value to Set.
	 */
	public void setCtSessionId(String v){
		try{
		setProperty(SCHEMA_ELEMENT_NAME + "/ct_session_id",v);
		_CtSessionId=null;
		} catch (Exception e1) {logger.error(e1);}
	}

	//FIELD

	private String _AnonUrl=null;

	/**
	 * @return Returns the anon_url.
	 */
	public String getAnonUrl(){
		try{
			if (_AnonUrl==null){
				_AnonUrl=getStringProperty("anon_url");
				return _AnonUrl;
			}else {
				return _AnonUrl;
			}
		} catch (Exception e1) {logger.error(e1);return null;}
	}

	/**
	 * Sets the value for anon_url.
	 * @param v Value to Set.
	 */
	public void setAnonUrl(String v){
		try{
		setProperty(SCHEMA_ELEMENT_NAME + "/anon_url",v);
		_AnonUrl=null;
		} catch (Exception e1) {logger.error(e1);}
	}

	//FIELD

	private String _Name=null;

	/**
	 * @return Returns the name.
	 */
	public String getName(){
		try{
			if (_Name==null){
				_Name=getStringProperty("name");
				return _Name;
			}else {
				return _Name;
			}
		} catch (Exception e1) {logger.error(e1);return null;}
	}

	/**
	 * Sets the value for name.
	 * @param v Value to Set.
	 */
	public void setName(String v){
		try{
		setProperty(SCHEMA_ELEMENT_NAME + "/name",v);
		_Name=null;
		} catch (Exception e1) {logger.error(e1);}
	}

	//FIELD

	private String _LabelsCorrect=null;

	/**
	 * @return Returns the labels_correct.
	 */
	public String getLabelsCorrect(){
		try{
			if (_LabelsCorrect==null){
				_LabelsCorrect=getStringProperty("labels_correct");
				return _LabelsCorrect;
			}else {
				return _LabelsCorrect;
			}
		} catch (Exception e1) {logger.error(e1);return null;}
	}

	/**
	 * Sets the value for labels_correct.
	 * @param v Value to Set.
	 */
	public void setLabelsCorrect(String v){
		try{
		setProperty(SCHEMA_ELEMENT_NAME + "/labels_correct",v);
		_LabelsCorrect=null;
		} catch (Exception e1) {logger.error(e1);}
	}

	public static ArrayList<org.nrg.xdat.om.ClinicaltrialsClinicaltrial> getAllClinicaltrialsClinicaltrials(org.nrg.xft.security.UserI user,boolean preLoad)
	{
		ArrayList<org.nrg.xdat.om.ClinicaltrialsClinicaltrial> al = new ArrayList<org.nrg.xdat.om.ClinicaltrialsClinicaltrial>();

		try{
			org.nrg.xft.collections.ItemCollection items = org.nrg.xft.search.ItemSearch.GetAllItems(SCHEMA_ELEMENT_NAME,user,preLoad);
			al = org.nrg.xdat.base.BaseElement.WrapItems(items.getItems());
		} catch (Exception e) {
			logger.error("",e);
		}

		al.trimToSize();
		return al;
	}

	public static ArrayList<org.nrg.xdat.om.ClinicaltrialsClinicaltrial> getClinicaltrialsClinicaltrialsByField(String xmlPath, Object value, org.nrg.xft.security.UserI user,boolean preLoad)
	{
		ArrayList<org.nrg.xdat.om.ClinicaltrialsClinicaltrial> al = new ArrayList<org.nrg.xdat.om.ClinicaltrialsClinicaltrial>();
		try {
			org.nrg.xft.collections.ItemCollection items = org.nrg.xft.search.ItemSearch.GetItems(xmlPath,value,user,preLoad);
			al = org.nrg.xdat.base.BaseElement.WrapItems(items.getItems());
		} catch (Exception e) {
			logger.error("",e);
		}

		al.trimToSize();
		return al;
	}

	public static ArrayList<org.nrg.xdat.om.ClinicaltrialsClinicaltrial> getClinicaltrialsClinicaltrialsByField(org.nrg.xft.search.CriteriaCollection criteria, org.nrg.xft.security.UserI user,boolean preLoad)
	{
		ArrayList<org.nrg.xdat.om.ClinicaltrialsClinicaltrial> al = new ArrayList<org.nrg.xdat.om.ClinicaltrialsClinicaltrial>();
		try {
			org.nrg.xft.collections.ItemCollection items = org.nrg.xft.search.ItemSearch.GetItems(criteria,user,preLoad);
			al = org.nrg.xdat.base.BaseElement.WrapItems(items.getItems());
		} catch (Exception e) {
			logger.error("",e);
		}

		al.trimToSize();
		return al;
	}

	public static ClinicaltrialsClinicaltrial getClinicaltrialsClinicaltrialsById(Object value, org.nrg.xft.security.UserI user,boolean preLoad)
	{
		try {
			org.nrg.xft.collections.ItemCollection items = org.nrg.xft.search.ItemSearch.GetItems("clinicalTrials:clinicaltrial/id",value,user,preLoad);
			ItemI match = items.getFirst();
			if (match!=null)
				return (ClinicaltrialsClinicaltrial) org.nrg.xdat.base.BaseElement.GetGeneratedItem(match);
			else
				 return null;
		} catch (IllegalAccessException e) {
			final StackTraceElement[] stacktrace = e.getStackTrace();
			final String location = stacktrace == null || stacktrace.length == 0 ? "Unknown (no stack trace)" : stacktrace[0].toString();
			logger.error("The user " + user.getUsername() + " was denied access to the clinicalTrials:clinicaltrial/id instance with ID " + value + ". Occurred at: " + location + "\n" + e.getMessage());
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
	public ArrayList<ResourceFile> getFileResources(String rootPath, boolean preventLoop){
ArrayList<ResourceFile> _return = new ArrayList<ResourceFile>();
	 boolean localLoop = preventLoop;
	        localLoop = preventLoop;
	
	        //imageAssessorData
	        XnatImageassessordata childImageassessordata = (XnatImageassessordata)this.getImageassessordata();
	            if (childImageassessordata!=null){
	              for(ResourceFile rf: ((XnatImageassessordata)childImageassessordata).getFileResources(rootPath, localLoop)) {
	                 rf.setXpath("imageAssessorData[" + ((XnatImageassessordata)childImageassessordata).getItem().getPKString() + "]/" + rf.getXpath());
	                 rf.setXdatPath("imageAssessorData/" + ((XnatImageassessordata)childImageassessordata).getItem().getPKString() + "/" + rf.getXpath());
	                 _return.add(rf);
	              }
	            }
	
	        localLoop = preventLoop;
	
	return _return;
}
}

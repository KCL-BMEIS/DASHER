/*
 * GENERATED FILE
 * Created on Thu Feb 20 15:54:22 GMT 2020
 *
 */
package org.nrg.xdat.bean;
import org.apache.log4j.Logger;
import org.nrg.xdat.bean.base.BaseElement;

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
public class ClinicaltrialsClinicaltrialBean extends XnatImageassessordataBean implements java.io.Serializable, org.nrg.xdat.model.ClinicaltrialsClinicaltrialI {
	public static final Logger logger = Logger.getLogger(ClinicaltrialsClinicaltrialBean.class);
	public static final String SCHEMA_ELEMENT_NAME="clinicalTrials:clinicaltrial";

	public String getSchemaElementName(){
		return "clinicaltrial";
	}

	public String getFullSchemaElementName(){
		return "clinicalTrials:clinicaltrial";
	}

	//FIELD

	private String _CtId=null;

	/**
	 * @return Returns the ct_id.
	 */
	public String getCtId(){
		return _CtId;
	}

	/**
	 * Sets the value for ct_id.
	 * @param v Value to Set.
	 */
	public void setCtId(String v){
		_CtId=v;
	}

	//FIELD

	private String _CtSubjectId=null;

	/**
	 * @return Returns the ct_subject_id.
	 */
	public String getCtSubjectId(){
		return _CtSubjectId;
	}

	/**
	 * Sets the value for ct_subject_id.
	 * @param v Value to Set.
	 */
	public void setCtSubjectId(String v){
		_CtSubjectId=v;
	}

	//FIELD

	private String _CtSessionId=null;

	/**
	 * @return Returns the ct_session_id.
	 */
	public String getCtSessionId(){
		return _CtSessionId;
	}

	/**
	 * Sets the value for ct_session_id.
	 * @param v Value to Set.
	 */
	public void setCtSessionId(String v){
		_CtSessionId=v;
	}

	//FIELD

	private String _AnonUrl=null;

	/**
	 * @return Returns the anon_url.
	 */
	public String getAnonUrl(){
		return _AnonUrl;
	}

	/**
	 * Sets the value for anon_url.
	 * @param v Value to Set.
	 */
	public void setAnonUrl(String v){
		_AnonUrl=v;
	}

	//FIELD

	private String _Name=null;

	/**
	 * @return Returns the name.
	 */
	public String getName(){
		return _Name;
	}

	/**
	 * Sets the value for name.
	 * @param v Value to Set.
	 */
	public void setName(String v){
		_Name=v;
	}

	//FIELD

	private String _LabelsCorrect=null;

	/**
	 * @return Returns the labels_correct.
	 */
	public String getLabelsCorrect(){
		return _LabelsCorrect;
	}

	/**
	 * Sets the value for labels_correct.
	 * @param v Value to Set.
	 */
	public void setLabelsCorrect(String v){
		_LabelsCorrect=v;
	}

	/**
	 * Sets the value for a field via the XMLPATH.
	 * @param v Value to Set.
	 */
	public void setDataField(String xmlPath,String v) throws BaseElement.UnknownFieldException{
		if (xmlPath.equals("ct_id")){
			setCtId(v);
		}else if (xmlPath.equals("ct_subject_id")){
			setCtSubjectId(v);
		}else if (xmlPath.equals("ct_session_id")){
			setCtSessionId(v);
		}else if (xmlPath.equals("anon_url")){
			setAnonUrl(v);
		}else if (xmlPath.equals("name")){
			setName(v);
		}else if (xmlPath.equals("labels_correct")){
			setLabelsCorrect(v);
		}
		else{
			super.setDataField(xmlPath,v);
		}
	}

	/**
	 * Sets the value for a field via the XMLPATH.
	 * @param v Value to Set.
	 */
	public void setReferenceField(String xmlPath,BaseElement v) throws BaseElement.UnknownFieldException{
			super.setReferenceField(xmlPath,v);
	}

	/**
	 * Gets the value for a field via the XMLPATH.
	 * @param v Value to Set.
	 */
	public Object getDataFieldValue(String xmlPath) throws BaseElement.UnknownFieldException{
		if (xmlPath.equals("ct_id")){
			return getCtId();
		}else if (xmlPath.equals("ct_subject_id")){
			return getCtSubjectId();
		}else if (xmlPath.equals("ct_session_id")){
			return getCtSessionId();
		}else if (xmlPath.equals("anon_url")){
			return getAnonUrl();
		}else if (xmlPath.equals("name")){
			return getName();
		}else if (xmlPath.equals("labels_correct")){
			return getLabelsCorrect();
		}
		else{
			return super.getDataFieldValue(xmlPath);
		}
	}

	/**
	 * Gets the value for a field via the XMLPATH.
	 * @param v Value to Set.
	 */
	public Object getReferenceField(String xmlPath) throws BaseElement.UnknownFieldException{
			return super.getReferenceField(xmlPath);
	}

	/**
	 * Gets the value for a field via the XMLPATH.
	 * @param v Value to Set.
	 */
	public String getReferenceFieldName(String xmlPath) throws BaseElement.UnknownFieldException{
			return super.getReferenceFieldName(xmlPath);
	}

	/**
	 * Returns whether or not this is a reference field
	 */
	public String getFieldType(String xmlPath) throws BaseElement.UnknownFieldException{
		if (xmlPath.equals("ct_id")){
			return BaseElement.field_data;
		}else if (xmlPath.equals("ct_subject_id")){
			return BaseElement.field_data;
		}else if (xmlPath.equals("ct_session_id")){
			return BaseElement.field_data;
		}else if (xmlPath.equals("anon_url")){
			return BaseElement.field_data;
		}else if (xmlPath.equals("name")){
			return BaseElement.field_data;
		}else if (xmlPath.equals("labels_correct")){
			return BaseElement.field_data;
		}
		else{
			return super.getFieldType(xmlPath);
		}
	}

	/**
	 * Returns arraylist of all fields
	 */
	public ArrayList getAllFields() {
		ArrayList all_fields=new ArrayList();
		all_fields.add("ct_id");
		all_fields.add("ct_subject_id");
		all_fields.add("ct_session_id");
		all_fields.add("anon_url");
		all_fields.add("name");
		all_fields.add("labels_correct");
		all_fields.addAll(super.getAllFields());
		return all_fields;
	}


	public String toString(){
		java.io.StringWriter sw = new java.io.StringWriter();
		try{this.toXML(sw,true);}catch(java.io.IOException e){}
		return sw.toString();
	}


	public void toXML(java.io.Writer writer,boolean prettyPrint) throws java.io.IOException{
		writer.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
		writer.write("\n<clinicalTrials:clinicaltrialAssessment");
		TreeMap map = new TreeMap();
		map.putAll(getXMLAtts());
		map.put("xmlns:arc","http://nrg.wustl.edu/arc");
		map.put("xmlns:cat","http://nrg.wustl.edu/catalog");
		map.put("xmlns:clinicalTrials","http://localhost/clinicalTrials");
		map.put("xmlns:pipe","http://nrg.wustl.edu/pipe");
		map.put("xmlns:prov","http://www.nbirn.net/prov");
		map.put("xmlns:scr","http://nrg.wustl.edu/scr");
		map.put("xmlns:val","http://nrg.wustl.edu/val");
		map.put("xmlns:wrk","http://nrg.wustl.edu/workflow");
		map.put("xmlns:xdat","http://nrg.wustl.edu/security");
		map.put("xmlns:xnat","http://nrg.wustl.edu/xnat");
		map.put("xmlns:xnat_a","http://nrg.wustl.edu/xnat_assessments");
		map.put("xmlns:xsi","http://www.w3.org/2001/XMLSchema-instance");
		java.util.Iterator iter =map.keySet().iterator();
		while(iter.hasNext()){
			String key = (String)iter.next();
			writer.write(" " + key + "=\"" + map.get(key) + "\"");
		}
		int header = 0;
		if (prettyPrint)header++;
		writer.write(">");
		addXMLBody(writer,header);
		if (prettyPrint)header--;
		writer.write("\n</clinicalTrials:clinicaltrialAssessment>");
	}


	protected void addXMLAtts(java.io.Writer writer) throws java.io.IOException{
		TreeMap map = this.getXMLAtts();
		java.util.Iterator iter =map.keySet().iterator();
		while(iter.hasNext()){
			String key = (String)iter.next();
			writer.write(" " + key + "=\"" + map.get(key) + "\"");
		}
	}


	protected TreeMap getXMLAtts() {
		TreeMap map = super.getXMLAtts();
		return map;
	}


	protected boolean addXMLBody(java.io.Writer writer, int header) throws java.io.IOException{
		super.addXMLBody(writer,header);
		//REFERENCE FROM clinicaltrial -> imageAssessorData
		if (_CtId!=null){
			writer.write("\n" + createHeader(header++) + "<clinicalTrials:ct_id");
			writer.write(">");
			writer.write(ValueParser(_CtId,"string"));
			writer.write("</clinicalTrials:ct_id>");
			header--;
		}
		if (_CtSubjectId!=null){
			writer.write("\n" + createHeader(header++) + "<clinicalTrials:ct_subject_id");
			writer.write(">");
			writer.write(ValueParser(_CtSubjectId,"string"));
			writer.write("</clinicalTrials:ct_subject_id>");
			header--;
		}
		if (_CtSessionId!=null){
			writer.write("\n" + createHeader(header++) + "<clinicalTrials:ct_session_id");
			writer.write(">");
			writer.write(ValueParser(_CtSessionId,"string"));
			writer.write("</clinicalTrials:ct_session_id>");
			header--;
		}
		if (_AnonUrl!=null){
			writer.write("\n" + createHeader(header++) + "<clinicalTrials:anon_url");
			writer.write(">");
			writer.write(ValueParser(_AnonUrl,"string"));
			writer.write("</clinicalTrials:anon_url>");
			header--;
		}
		if (_Name!=null){
			writer.write("\n" + createHeader(header++) + "<clinicalTrials:name");
			writer.write(">");
			writer.write(ValueParser(_Name,"string"));
			writer.write("</clinicalTrials:name>");
			header--;
		}
		if (_LabelsCorrect!=null){
			writer.write("\n" + createHeader(header++) + "<clinicalTrials:labels_correct");
			writer.write(">");
			writer.write(ValueParser(_LabelsCorrect,"string"));
			writer.write("</clinicalTrials:labels_correct>");
			header--;
		}
	return true;
	}


	protected boolean hasXMLBodyContent(){
		if (_CtId!=null) return true;
		if (_CtSubjectId!=null) return true;
		if (_CtSessionId!=null) return true;
		if (_AnonUrl!=null) return true;
		if (_Name!=null) return true;
		if (_LabelsCorrect!=null) return true;
		if(super.hasXMLBodyContent())return true;
		return false;
	}
}

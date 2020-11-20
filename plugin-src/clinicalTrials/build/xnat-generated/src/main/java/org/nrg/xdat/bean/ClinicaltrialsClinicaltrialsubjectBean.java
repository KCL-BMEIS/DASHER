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
public class ClinicaltrialsClinicaltrialsubjectBean extends XnatSubjectassessordataBean implements java.io.Serializable, org.nrg.xdat.model.ClinicaltrialsClinicaltrialsubjectI {
	public static final Logger logger = Logger.getLogger(ClinicaltrialsClinicaltrialsubjectBean.class);
	public static final String SCHEMA_ELEMENT_NAME="clinicalTrials:clinicaltrialsubject";

	public String getSchemaElementName(){
		return "clinicaltrialsubject";
	}

	public String getFullSchemaElementName(){
		return "clinicalTrials:clinicaltrialsubject";
	}

	//FIELD

	private String _ResearchSubjectId=null;

	/**
	 * @return Returns the research_subject_id.
	 */
	public String getResearchSubjectId(){
		return _ResearchSubjectId;
	}

	/**
	 * Sets the value for research_subject_id.
	 * @param v Value to Set.
	 */
	public void setResearchSubjectId(String v){
		_ResearchSubjectId=v;
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

	/**
	 * Sets the value for a field via the XMLPATH.
	 * @param v Value to Set.
	 */
	public void setDataField(String xmlPath,String v) throws BaseElement.UnknownFieldException{
		if (xmlPath.equals("research_subject_id")){
			setResearchSubjectId(v);
		}else if (xmlPath.equals("ct_subject_id")){
			setCtSubjectId(v);
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
		if (xmlPath.equals("research_subject_id")){
			return getResearchSubjectId();
		}else if (xmlPath.equals("ct_subject_id")){
			return getCtSubjectId();
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
		if (xmlPath.equals("research_subject_id")){
			return BaseElement.field_data;
		}else if (xmlPath.equals("ct_subject_id")){
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
		all_fields.add("research_subject_id");
		all_fields.add("ct_subject_id");
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
		writer.write("\n<clinicalTrials:clinicaltrialSubjectAssessment");
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
		writer.write("\n</clinicalTrials:clinicaltrialSubjectAssessment>");
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
		//REFERENCE FROM clinicaltrialsubject -> subjectAssessorData
		if (_ResearchSubjectId!=null){
			writer.write("\n" + createHeader(header++) + "<clinicalTrials:research_subject_id");
			writer.write(">");
			writer.write(ValueParser(_ResearchSubjectId,"string"));
			writer.write("</clinicalTrials:research_subject_id>");
			header--;
		}
		if (_CtSubjectId!=null){
			writer.write("\n" + createHeader(header++) + "<clinicalTrials:ct_subject_id");
			writer.write(">");
			writer.write(ValueParser(_CtSubjectId,"string"));
			writer.write("</clinicalTrials:ct_subject_id>");
			header--;
		}
	return true;
	}


	protected boolean hasXMLBodyContent(){
		if (_ResearchSubjectId!=null) return true;
		if (_CtSubjectId!=null) return true;
		if(super.hasXMLBodyContent())return true;
		return false;
	}
}

/*
 * GENERATED FILE
 * Created on Thu Feb 20 15:54:22 GMT 2020
 *
 */

/**
 * @author XDAT
 *
 */

function clinicalTrials_clinicaltrialsubject(){
this.xsiType="clinicalTrials:clinicaltrialsubject";

	this.getSchemaElementName=function(){
		return "clinicaltrialsubject";
	}

	this.getFullSchemaElementName=function(){
		return "clinicalTrials:clinicaltrialsubject";
	}
this.extension=dynamicJSLoad('xnat_subjectAssessorData','generated/xnat_subjectAssessorData.js');

	this.ResearchSubjectId=null;


	function getResearchSubjectId() {
		return this.ResearchSubjectId;
	}
	this.getResearchSubjectId=getResearchSubjectId;


	function setResearchSubjectId(v){
		this.ResearchSubjectId=v;
	}
	this.setResearchSubjectId=setResearchSubjectId;

	this.CtSubjectId=null;


	function getCtSubjectId() {
		return this.CtSubjectId;
	}
	this.getCtSubjectId=getCtSubjectId;


	function setCtSubjectId(v){
		this.CtSubjectId=v;
	}
	this.setCtSubjectId=setCtSubjectId;


	this.getProperty=function(xmlPath){
			if(xmlPath.startsWith(this.getFullSchemaElementName())){
				xmlPath=xmlPath.substring(this.getFullSchemaElementName().length + 1);
			}
			if(xmlPath=="subjectAssessorData"){
				return this.Subjectassessordata ;
			} else 
			if(xmlPath.startsWith("subjectAssessorData")){
				xmlPath=xmlPath.substring(19);
				if(xmlPath=="")return this.Subjectassessordata ;
				if(xmlPath.startsWith("[")){
					if (xmlPath.indexOf("/")>-1){
						var optionString=xmlPath.substring(0,xmlPath.indexOf("/"));
						xmlPath=xmlPath.substring(xmlPath.indexOf("/")+1);
					}else{
						var optionString=xmlPath;
						xmlPath="";
					}
					
					var options = loadOptions(optionString);//omUtils.js
				}else{xmlPath=xmlPath.substring(1);}
				if(this.Subjectassessordata!=undefined)return this.Subjectassessordata.getProperty(xmlPath);
				else return null;
			} else 
			if(xmlPath=="research_subject_id"){
				return this.ResearchSubjectId ;
			} else 
			if(xmlPath=="ct_subject_id"){
				return this.CtSubjectId ;
			} else 
			if(xmlPath=="meta"){
				return this.Meta ;
			} else 
			{
				return this.extension.getProperty(xmlPath);
			}
	}


	this.setProperty=function(xmlPath,value){
			if(xmlPath.startsWith(this.getFullSchemaElementName())){
				xmlPath=xmlPath.substring(this.getFullSchemaElementName().length + 1);
			}
			if(xmlPath=="subjectAssessorData"){
				this.Subjectassessordata=value;
			} else 
			if(xmlPath.startsWith("subjectAssessorData")){
				xmlPath=xmlPath.substring(19);
				if(xmlPath=="")return this.Subjectassessordata ;
				if(xmlPath.startsWith("[")){
					if (xmlPath.indexOf("/")>-1){
						var optionString=xmlPath.substring(0,xmlPath.indexOf("/"));
						xmlPath=xmlPath.substring(xmlPath.indexOf("/")+1);
					}else{
						var optionString=xmlPath;
						xmlPath="";
					}
					
					var options = loadOptions(optionString);//omUtils.js
				}else{xmlPath=xmlPath.substring(1);}
				if(this.Subjectassessordata!=undefined){
					this.Subjectassessordata.setProperty(xmlPath,value);
				}else{
						if(options && options.xsiType){
							this.Subjectassessordata= instanciateObject(options.xsiType);//omUtils.js
						}else{
							this.Subjectassessordata= instanciateObject("xnat:subjectAssessorData");//omUtils.js
						}
						if(options && options.where)this.Subjectassessordata.setProperty(options.where.field,options.where.value);
						this.Subjectassessordata.setProperty(xmlPath,value);
				}
			} else 
			if(xmlPath=="research_subject_id"){
				this.ResearchSubjectId=value;
			} else 
			if(xmlPath=="ct_subject_id"){
				this.CtSubjectId=value;
			} else 
			if(xmlPath=="meta"){
				this.Meta=value;
			} else 
			{
				return this.extension.setProperty(xmlPath,value);
			}
	}

	/**
	 * Sets the value for a field via the XMLPATH.
	 * @param v Value to Set.
	 */
	this.setReferenceField=function(xmlPath,v) {
			this.extension.setReferenceField(xmlPath,v);
	}

	/**
	 * Gets the value for a field via the XMLPATH.
	 * @param v Value to Set.
	 */
	this.getReferenceFieldName=function(xmlPath) {
			return this.extension.getReferenceFieldName(xmlPath);
	}

	/**
	 * Returns whether or not this is a reference field
	 */
	this.getFieldType=function(xmlPath){
		if (xmlPath=="research_subject_id"){
			return "field_data";
		}else if (xmlPath=="ct_subject_id"){
			return "field_data";
		}
		else{
			return this.extension.getFieldType(xmlPath);
		}
	}


	this.toXML=function(xmlTxt,preventComments){
		xmlTxt+="<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
		xmlTxt+="\n<clinicalTrials:clinicaltrialSubjectAssessment";
		xmlTxt+=this.getXMLAtts();
		xmlTxt+=" xmlns:arc=\"http://nrg.wustl.edu/arc\"";
		xmlTxt+=" xmlns:cat=\"http://nrg.wustl.edu/catalog\"";
		xmlTxt+=" xmlns:clinicalTrials=\"http://localhost/clinicalTrials\"";
		xmlTxt+=" xmlns:pipe=\"http://nrg.wustl.edu/pipe\"";
		xmlTxt+=" xmlns:prov=\"http://www.nbirn.net/prov\"";
		xmlTxt+=" xmlns:scr=\"http://nrg.wustl.edu/scr\"";
		xmlTxt+=" xmlns:val=\"http://nrg.wustl.edu/val\"";
		xmlTxt+=" xmlns:wrk=\"http://nrg.wustl.edu/workflow\"";
		xmlTxt+=" xmlns:xdat=\"http://nrg.wustl.edu/security\"";
		xmlTxt+=" xmlns:xnat=\"http://nrg.wustl.edu/xnat\"";
		xmlTxt+=" xmlns:xnat_a=\"http://nrg.wustl.edu/xnat_assessments\"";
		xmlTxt+=" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"";
		xmlTxt+=">";
		xmlTxt+=this.getXMLBody(preventComments)
		xmlTxt+="\n</clinicalTrials:clinicaltrialSubjectAssessment>";
		return xmlTxt;
	}


	this.getXMLComments=function(preventComments){
		var str ="";
		if((preventComments==undefined || !preventComments) && this.hasXMLComments()){
		}
		return str;
	}


	this.getXMLAtts=function(){
		var attTxt = this.extension.getXMLAtts();
		return attTxt;
	}


	this.getXMLBody=function(preventComments){
		var xmlTxt=this.getXMLComments(preventComments);
		xmlTxt+=this.extension.getXMLBody(preventComments);
		if (this.ResearchSubjectId!=null){
			xmlTxt+="\n<clinicalTrials:research_subject_id";
			xmlTxt+=">";
			xmlTxt+=this.ResearchSubjectId.replace(/>/g,"&gt;").replace(/</g,"&lt;");
			xmlTxt+="</clinicalTrials:research_subject_id>";
		}
		if (this.CtSubjectId!=null){
			xmlTxt+="\n<clinicalTrials:ct_subject_id";
			xmlTxt+=">";
			xmlTxt+=this.CtSubjectId.replace(/>/g,"&gt;").replace(/</g,"&lt;");
			xmlTxt+="</clinicalTrials:ct_subject_id>";
		}
		return xmlTxt;
	}


	this.hasXMLComments=function(){
	}


	this.hasXMLBodyContent=function(){
		if (this.ResearchSubjectId!=null) return true;
		if (this.CtSubjectId!=null) return true;
		if(this.hasXMLComments())return true;
		if(this.extension.hasXMLBodyContent())return true;
		return false;
	}
}

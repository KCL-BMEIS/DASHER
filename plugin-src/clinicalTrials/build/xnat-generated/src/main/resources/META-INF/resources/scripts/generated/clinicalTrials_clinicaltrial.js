/*
 * GENERATED FILE
 * Created on Thu Feb 20 15:54:22 GMT 2020
 *
 */

/**
 * @author XDAT
 *
 */

function clinicalTrials_clinicaltrial(){
this.xsiType="clinicalTrials:clinicaltrial";

	this.getSchemaElementName=function(){
		return "clinicaltrial";
	}

	this.getFullSchemaElementName=function(){
		return "clinicalTrials:clinicaltrial";
	}
this.extension=dynamicJSLoad('xnat_imageAssessorData','generated/xnat_imageAssessorData.js');

	this.CtId=null;


	function getCtId() {
		return this.CtId;
	}
	this.getCtId=getCtId;


	function setCtId(v){
		this.CtId=v;
	}
	this.setCtId=setCtId;

	this.CtSubjectId=null;


	function getCtSubjectId() {
		return this.CtSubjectId;
	}
	this.getCtSubjectId=getCtSubjectId;


	function setCtSubjectId(v){
		this.CtSubjectId=v;
	}
	this.setCtSubjectId=setCtSubjectId;

	this.CtSessionId=null;


	function getCtSessionId() {
		return this.CtSessionId;
	}
	this.getCtSessionId=getCtSessionId;


	function setCtSessionId(v){
		this.CtSessionId=v;
	}
	this.setCtSessionId=setCtSessionId;

	this.AnonUrl=null;


	function getAnonUrl() {
		return this.AnonUrl;
	}
	this.getAnonUrl=getAnonUrl;


	function setAnonUrl(v){
		this.AnonUrl=v;
	}
	this.setAnonUrl=setAnonUrl;

	this.Name=null;


	function getName() {
		return this.Name;
	}
	this.getName=getName;


	function setName(v){
		this.Name=v;
	}
	this.setName=setName;

	this.LabelsCorrect=null;


	function getLabelsCorrect() {
		return this.LabelsCorrect;
	}
	this.getLabelsCorrect=getLabelsCorrect;


	function setLabelsCorrect(v){
		this.LabelsCorrect=v;
	}
	this.setLabelsCorrect=setLabelsCorrect;


	this.getProperty=function(xmlPath){
			if(xmlPath.startsWith(this.getFullSchemaElementName())){
				xmlPath=xmlPath.substring(this.getFullSchemaElementName().length + 1);
			}
			if(xmlPath=="imageAssessorData"){
				return this.Imageassessordata ;
			} else 
			if(xmlPath.startsWith("imageAssessorData")){
				xmlPath=xmlPath.substring(17);
				if(xmlPath=="")return this.Imageassessordata ;
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
				if(this.Imageassessordata!=undefined)return this.Imageassessordata.getProperty(xmlPath);
				else return null;
			} else 
			if(xmlPath=="ct_id"){
				return this.CtId ;
			} else 
			if(xmlPath=="ct_subject_id"){
				return this.CtSubjectId ;
			} else 
			if(xmlPath=="ct_session_id"){
				return this.CtSessionId ;
			} else 
			if(xmlPath=="anon_url"){
				return this.AnonUrl ;
			} else 
			if(xmlPath=="name"){
				return this.Name ;
			} else 
			if(xmlPath=="labels_correct"){
				return this.LabelsCorrect ;
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
			if(xmlPath=="imageAssessorData"){
				this.Imageassessordata=value;
			} else 
			if(xmlPath.startsWith("imageAssessorData")){
				xmlPath=xmlPath.substring(17);
				if(xmlPath=="")return this.Imageassessordata ;
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
				if(this.Imageassessordata!=undefined){
					this.Imageassessordata.setProperty(xmlPath,value);
				}else{
						if(options && options.xsiType){
							this.Imageassessordata= instanciateObject(options.xsiType);//omUtils.js
						}else{
							this.Imageassessordata= instanciateObject("xnat:imageAssessorData");//omUtils.js
						}
						if(options && options.where)this.Imageassessordata.setProperty(options.where.field,options.where.value);
						this.Imageassessordata.setProperty(xmlPath,value);
				}
			} else 
			if(xmlPath=="ct_id"){
				this.CtId=value;
			} else 
			if(xmlPath=="ct_subject_id"){
				this.CtSubjectId=value;
			} else 
			if(xmlPath=="ct_session_id"){
				this.CtSessionId=value;
			} else 
			if(xmlPath=="anon_url"){
				this.AnonUrl=value;
			} else 
			if(xmlPath=="name"){
				this.Name=value;
			} else 
			if(xmlPath=="labels_correct"){
				this.LabelsCorrect=value;
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
		if (xmlPath=="ct_id"){
			return "field_data";
		}else if (xmlPath=="ct_subject_id"){
			return "field_data";
		}else if (xmlPath=="ct_session_id"){
			return "field_data";
		}else if (xmlPath=="anon_url"){
			return "field_data";
		}else if (xmlPath=="name"){
			return "field_data";
		}else if (xmlPath=="labels_correct"){
			return "field_data";
		}
		else{
			return this.extension.getFieldType(xmlPath);
		}
	}


	this.toXML=function(xmlTxt,preventComments){
		xmlTxt+="<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
		xmlTxt+="\n<clinicalTrials:clinicaltrialAssessment";
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
		xmlTxt+="\n</clinicalTrials:clinicaltrialAssessment>";
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
		if (this.CtId!=null){
			xmlTxt+="\n<clinicalTrials:ct_id";
			xmlTxt+=">";
			xmlTxt+=this.CtId.replace(/>/g,"&gt;").replace(/</g,"&lt;");
			xmlTxt+="</clinicalTrials:ct_id>";
		}
		if (this.CtSubjectId!=null){
			xmlTxt+="\n<clinicalTrials:ct_subject_id";
			xmlTxt+=">";
			xmlTxt+=this.CtSubjectId.replace(/>/g,"&gt;").replace(/</g,"&lt;");
			xmlTxt+="</clinicalTrials:ct_subject_id>";
		}
		if (this.CtSessionId!=null){
			xmlTxt+="\n<clinicalTrials:ct_session_id";
			xmlTxt+=">";
			xmlTxt+=this.CtSessionId.replace(/>/g,"&gt;").replace(/</g,"&lt;");
			xmlTxt+="</clinicalTrials:ct_session_id>";
		}
		if (this.AnonUrl!=null){
			xmlTxt+="\n<clinicalTrials:anon_url";
			xmlTxt+=">";
			xmlTxt+=this.AnonUrl.replace(/>/g,"&gt;").replace(/</g,"&lt;");
			xmlTxt+="</clinicalTrials:anon_url>";
		}
		if (this.Name!=null){
			xmlTxt+="\n<clinicalTrials:name";
			xmlTxt+=">";
			xmlTxt+=this.Name.replace(/>/g,"&gt;").replace(/</g,"&lt;");
			xmlTxt+="</clinicalTrials:name>";
		}
		if (this.LabelsCorrect!=null){
			xmlTxt+="\n<clinicalTrials:labels_correct";
			xmlTxt+=">";
			xmlTxt+=this.LabelsCorrect.replace(/>/g,"&gt;").replace(/</g,"&lt;");
			xmlTxt+="</clinicalTrials:labels_correct>";
		}
		return xmlTxt;
	}


	this.hasXMLComments=function(){
	}


	this.hasXMLBodyContent=function(){
		if (this.CtId!=null) return true;
		if (this.CtSubjectId!=null) return true;
		if (this.CtSessionId!=null) return true;
		if (this.AnonUrl!=null) return true;
		if (this.Name!=null) return true;
		if (this.LabelsCorrect!=null) return true;
		if(this.hasXMLComments())return true;
		if(this.extension.hasXMLBodyContent())return true;
		return false;
	}
}

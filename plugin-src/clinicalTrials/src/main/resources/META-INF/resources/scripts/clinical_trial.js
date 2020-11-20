//var project = data.$project
//var session_label = data.$label
var project = document.getElementById("param[2][0].value").value;
var session_label = document.getElementById("param[1][0].value").value;
var subject_id = document.getElementById("param[0][0].value").value;
var labels;
var prev_ct_subject_id = "ClinicalTrial_Subject_ID";
var prev_research_subject_id = "Research_Subject_ID";

 
var txt="";
var xhttp = new XMLHttpRequest();
var url_sub = serverRoot + "/data/projects/" +  project + "/subjects/" ;
url_sub = url_sub +  subject_id + "?format=xml";
xhttp.open("GET", url_sub , true);
xhttp.onreadystatechange = function() {
    if (xhttp.readyState == 4 && xhttp.status == 200) {
        txt_sub = xhttp.responseText;

        var txt_fields =txt_sub.split("fields>")
        var fields = txt_fields[1].split("field>")
        for (var i = 0; i < fields.length; i++) {
          if ( fields[i].search("ct_subject_id" ) > 0 ) {
             prev_ct_subject_id = fields[i].split("-->")[1].replace("</xnat:","");
          } 
          if ( fields[i].search("research_subject_id" ) > 0 ) {
            prev_research_subject_id = fields[i].split("-->")[1].replace("</xnat:","");
          } 
        }
   }
};
xhttp.send(null);



var txtFile3 = new XMLHttpRequest();
var url = serverRoot + "/data/projects/" +  project;
url = url + "/resources/anonymised_projects/files/anon_projects.csv";
txtFile3.open("GET", url , true);
txtFile3.onreadystatechange = function() {
  if (txtFile3.readyState === 4) {  // Makes sure the document is ready to parse.
    if (txtFile3.status === 200) {  // Makes sure it's found the file.
      var allText = txtFile3.responseText;
      var projs = txtFile3.responseText.split("\n"); // Will separate each line into an array
      var select3 = document.getElementById("selectProject");
      // skip first line, header of csv
      for(var i = 1; i < projs.length; i++) {
         if (projs[i].length > 1 ) {
            var proj = projs[i].split(",");
            var opt = proj[0];
            var el3 = document.createElement("option");
            el3.textContent = opt;
            el3.value = opt;
            select3.appendChild(el3);
        }
      }
    }
  }
};
txtFile3.send(null);




var txtFile = new XMLHttpRequest();
var url = serverRoot + "/data/projects/" +  project;
url = url + "/resources/clinical_trials/files/clinical_trial_names.txt";
txtFile.open("GET", url , true);
txtFile.onreadystatechange = function() {
  if (txtFile.readyState === 4) {  // Makes sure the document is ready to parse.
    if (txtFile.status === 200) {  // Makes sure it's found the file.
      var allText = txtFile.responseText;
      var clinical_trials = txtFile.responseText.split("\n"); // Will separate each line into an array
      var select = document.getElementById("selectClinicalTrial");
      for(var i = 0; i < clinical_trials.length; i++) {
         if (clinical_trials[i].length > 1 ) {
            var opt = clinical_trials[i];
            var el = document.createElement("option");
            el.textContent = opt;
            el.value = opt;
            select.appendChild(el);
        }
      }
    }
  }
};
txtFile.send(null);


var txtFile2 = new XMLHttpRequest();

var url = serverRoot + "/data/projects/" +  project + "/subjects/" + subject_id + "/experiments/" ;
url = url + session_label + "/resources/roi_labels/files/roi_labels.txt";
txtFile2.open("GET", url , true);
txtFile2.onreadystatechange = function() {
  if (txtFile2.readyState === 4) {  // Makes sure the document is ready to parse.
    if (txtFile2.status === 200) {  // Makes sure it's found the file.
      var allText = txtFile2.responseText;
      var labels = txtFile2.responseText.split("\n"); // Will separate each line into an array
      var e =  "";
      label_number=0;
        for(var i = 0; i < labels.length; i++) {

          if (labels[i].length > 1 ) {
            var lab =  labels[i];
            e += "<TR><TH width=\"200\">" + lab  + "</TH><TH width=\"200\"><input type='text' id='label_"+ label_number +"' class='new_label_class' value='" + lab + "' ></TH></TR>";  
            label_number=label_number+1;          
          }

        }
        document.getElementById("label_table").innerHTML = e;
    }
  }
};
txtFile2.send(null);


document.getElementById("submit_button").disabled=false;
document.getElementById("param[3][0].value").value = "__GENERATE__";
document.getElementById("param[8][0].value").value = "1" ;





function addCssClassToElement(element, cssClass) {
    element.className += " " + cssClass;
}

function removeCssClassFromElement(element, cssClass) {
    var reg = new RegExp('(\\s|^)' + cssClass + '(\\s|$)');
    element.className = element.className.replace(reg, ' ');
}

function togglePanel(panelId, display) {
    var panel = document.getElementById(panelId);
    if (display) {
        removeCssClassFromElement(panel, 'unhidden');
        removeCssClassFromElement(panel, 'hidden');
        addCssClassToElement(panel, 'unhidden');
    } else {
        removeCssClassFromElement(panel, 'unhidden');
        removeCssClassFromElement(panel, 'hidden');
        addCssClassToElement(panel, 'hidden');
    }
}


function setGenerate(){
    document.getElementById("param[3][0].value").value = "__GENERATE__";
    document.getElementById("validate_button").disabled=true;
    document.getElementById("submit_button").disabled=false;    
}




function readPermittedLabels(){
    
    var trial_name=document.getElementById("selectClinicalTrial").value;
    if (trial_name == "Select clinical trial"){
        togglePanel('roilabeldiv', false)
        document.getElementById("submit_button").disabled=true;
        document.getElementById("validate_button").disabled=true;
        document.getElementById("messages3").innerHTML="";

    }    
    else if (trial_name == "No Trial" ){
        togglePanel('roilabeldiv', false)
        document.getElementById("submit_button").disabled=false;
        document.getElementById("messages3").innerHTML="Not part of a Clinical Trial. Fill in the Subject and Session IDs and click 'Anonymise Session'";
        document.getElementById("validate_button").disabled=true;
        document.getElementById("param[3][0].value").value = "_RESEARCH_";
        document.getElementById("param[4][0].value").value = prev_research_subject_id;

       var proj_name=document.getElementById("selectProject").value;
       if (proj_name == "Select Pseudonymised Project"){
            document.getElementById("submit_button").disabled=true;
            document.getElementById("messages3").innerHTML="Select an Pseudonymised Project before Anonymising";
       }
        


        //var url = serverRoot + "/data/projects/" +  project + "/subjects/" + subject_id +  "/assessors/ct_info/"       
    }
    else {
        document.getElementById("submit_button").disabled=true;
        document.getElementById("validate_button").disabled=false;
        document.getElementById("param[4][0].value").value = prev_ct_subject_id;
        var txtFile = new XMLHttpRequest();
        var url = serverRoot + "/data/projects/" +  project + "/resources/clinical_trials/files/";
        url = url + trial_name + "_labels.txt";  
        txtFile.open("GET", url , true);
        txtFile.onreadystatechange = function() {
          if (txtFile.readyState === 4) {  // Makes sure the document is ready to parse.
            if (txtFile.status === 200) {  // Makes sure it's found the file.
              togglePanel('roilabeldiv', true)
              var permitted_labels = txtFile.responseText.split("\n"); // Will separate each line into an array
              var e = "";
              for(var i = 0; i < permitted_labels.length; i++) {
                  if (permitted_labels[i].length > 1 ) {
                      var opt =  permitted_labels[i];
                      e += "<li id=\"list_" + i + "\" >" + opt + "</li>";

                  }

              }
              document.getElementById("permitted_labels_list").innerHTML = e;
              document.getElementById("messages3").innerHTML="";
              //$.each(permitted_labels, function() {
               //     $('#labelsList').append($('<li>').text(this));
              //});
            }
          }
        };
        txtFile.send(null);
        /// GET REQUIRED LABELS
        var txtFile2 = new XMLHttpRequest();
        var url2 = serverRoot + "/data/projects/" +  project + "/resources/clinical_trials/files/";
        url2 = url2 + trial_name + "_required_labels.txt";  
        txtFile2.open("GET", url2 , true);
        txtFile2.onreadystatechange = function() {
          if (txtFile2.readyState === 4) {  // Makes sure the document is ready to parse.
            if (txtFile2.status === 200) {  // Makes sure it's found the file.
              togglePanel('roilabeldiv', true)
              var required_labels = txtFile2.responseText.split("\n"); // Will separate each line into an array
              var e2 = "";
              for(var i = 0; i < required_labels.length; i++) {
                  if (required_labels[i].length > 1 ) {
                      var opt =  required_labels[i];
                      e2 += "<li id=\"req_list_" + i + "\" >" + opt + "</li>";
                  }

              }
              document.getElementById("required_labels_list").innerHTML = e2;
              document.getElementById("messages3").innerHTML="";
              //$.each(permitted_labels, function() {
               //     $('#labelsList').append($('<li>').text(this));
              //});
            }
          }
        };
        txtFile2.send(null);




        
    }


}

function readProjects(){
     var proj_name=document.getElementById("selectProject").value;
     if (proj_name == "Select Pseudonymised Project"){          
          document.getElementById("messages3").innerHTML="Select an Pseudonymised Project";         
          togglePanel('autoormanual', false)
     }
     else{
           document.getElementById("param[7][0].value").value = proj_name;
           togglePanel('autoormanual', true)

     }
}





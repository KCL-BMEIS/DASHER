/**
 * Modified from the FixedDicomProjectIdentifier file by Matt Sanderson <matt.sanderson@mq.edu.au>
 * Original information:
 * web: org.nrg.dcm.id.FixedDicomProjectIdentifier
 * XNAT http://www.xnat.org
 * Copyright (c) 2005-2017, Washington University School of Medicine and Howard Hughes Medical Institute
 * All Rights Reserved
 *
 * Released under the Simplified BSD.
 */

package org.nrg.dcm.id;

import com.google.common.collect.ImmutableList;
import org.nrg.dcm.Extractor;
import org.nrg.dcm.TextExtractor;
import org.nrg.dcm.ConfigReader;
import org.nrg.dcm.ProtocolReader;
import org.nrg.dcm.ROIReader;

import java.util.SortedSet;
import java.util.List;

import org.dcm4che2.data.DicomObject;
import org.dcm4che2.data.Tag;
import org.nrg.xdat.om.XnatProjectdata;
import org.nrg.xft.security.UserI;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.google.common.collect.ImmutableSortedSet;

public final class UploaderDicomIdentifier implements DicomProjectIdentifier
{

    private static final ImmutableSortedSet<Integer> TAGS = ImmutableSortedSet.of();
    private String name = null;
    private ImmutableList<String> protocols = null;
    // The current name of the project. This is used to track if it changes to return a new XNAT project object
    private String proj_name = null;
    private XnatProjectdata _project;

    // Define a custom ImmutableList of Extractors to overwrite the default behaviour.
    // The session is usually extracted from the PatientID which we do not want, so we will overwrite this behaviour
    // to use the AccessionNumber in the DICOM header instead.
    // This could be defined in a separate class specifically for this, but since we already have this object created
    // we might as well use it.
    private static final ImmutableList<Extractor> sessionExtractors = new ImmutableList.Builder<Extractor>().add(new TextExtractor(Tag.PatientID)).build();

    static Logger logger = LoggerFactory.getLogger(UploaderDicomIdentifier.class);

    // Define the regex patterns reuired to extract the required information from the descriptions

    // this pattern will match (anything)^[info we want].
    // [info we want] must consist of letters and numbers, the matching stops once a non-alphanumeric character is hit
    private static final Pattern SIEMENS_PATTERN = Pattern.compile("(?:[^\\^]+)\\^((?:[a-zA-Z\\d]+))(.*?)");
    // this pattern will match (anything)[one of TOTAL, DINAD, BRAINPROJECT, or VAD](anything)
    private static final Pattern GE_PATTERN = Pattern.compile("(.*?)(TOTAL|DINAD|BRAINPROJECT|VAD|CHROME)(.*?)");

    // This doesn't seem to be called at any point, but removing it seems to cause the plugin to not work...
    // So best to just keep it...
    @SuppressWarnings("unused")
    public UploaderDicomIdentifier(final XnatProjectdata project) {
        _project = project;
    }



    /**
     * Main constructor.
     * For this project it is empty because we have no arguments or parameters we need to pass
     * to this class, however you can pass whatever you want here.
     * The value is passed as an argument in the Spring xml file like:
     * <constructor-arg ref=""/>
     * or
     * <constructor-arg value=""/>
     * in order of the declared arguments.
     * 
     * It should be noted that this constructor is only called when the identifier is first instantiated
     * (ie. when it receives it's first file.)
     * For this reason it's probably better if you need to do any logic based on data in the dicom file itself
     * to have this in the `apply` method.
     */
    public UploaderDicomIdentifier()
    {
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public SortedSet<Integer> getTags() {
        return TAGS;
    }

    /**
     * Main function which gets called by the CompositeDicomObjectIdentifier for each Dicom file.
     * Here we simply apply the regex expressions to the StudyDescription extracted from the Dicom file.
     * @return
     * XnatProjectdata as determined by whatever conditions are laid out in this method.
     */
    @Override
    public XnatProjectdata apply(final UserI user, final DicomObject o)
    {
        final String description = o.getString(Tag.StudyDescription);
        final String modality = o.getString(Tag.Modality);
        final String model = o.getString(Tag.ManufacturerModelName);
        final String permitted_modalities =  ProtocolReader.getModalaties();
        final String permitted_models =  ProtocolReader.getModels(); 

        //logger.trace("Modility: {} Model: {}  permitted_modalities: {}  perm models: {}", modality, model, permitted_modalities, permitted_models);
        //logger.trace("Modility: {}  permitted_modalities: {} ", modality, permitted_modalities);
        //logger.trace("Model: {}  permitted_models: {} ", model, permitted_models);

        // First, check for a match with the SIEMENS regex
        name = ConfigReader.getProject();
        //logger.trace("Permitted mods: {}", permitted_modalities);
        //logger.trace("Project name: {},  Modalilty: {}, Permitted modalities: ", name, modality);
        if (!permitted_modalities.contains("ALL")){
            if (!permitted_modalities.contains(modality)){
                //logger.trace("Modility: {} not found in protocol, permitted_modalities: {} ", modality, permitted_modalities);
                name="QUARANTINE";
            }
        }
        if (!permitted_models.contains("ALL")){
            if (permitted_models.contains(model)){
                //logger.trace("Modility: {} not found in protocol, permitted_modalities: {} ", modality, permitted_modalities);
                name="QUARANTINE";
            }
        }
     

    	_project = XnatProjectdata.getProjectByIDorAlias(name, user, false);


        return _project;
    }

    // public method to allow the session extractor list to be retreived by the spring xml file.
    // This will be called the "MQSessionIdent" bean in this xml file and will be passed to the
    // CompositeDicomObjectIdentifier as an argument in place of the default vanilla Extractor.
    public static List<Extractor> getSessionExtractors() { return sessionExtractors; }

    @Override
    public void reset() {
        // Nothing to do here since this is just set at initialization.
    }
}

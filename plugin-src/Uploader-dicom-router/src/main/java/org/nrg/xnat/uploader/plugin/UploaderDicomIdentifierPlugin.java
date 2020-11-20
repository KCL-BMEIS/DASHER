package org.nrg.xnat.uploader.plugin;
import org.apache.log4j.Logger;
import org.nrg.framework.annotations.XnatPlugin;
import org.springframework.context.annotation.ImportResource;

@XnatPlugin(value = "Uploader_DicomIdentifier",
            name = "KCL XNAT Uploader Dicom SCP Routing Plugin",
            description = "Automatically routes Dicom files uploaded via SCP.",
            entityPackages = "org.nrg.framework.orm.hibernate.HibernateEntityPackageList",
            log4jPropertiesFile = "module-log4j.properties")
@ImportResource("WEB-INF/conf/Uploader-import-context.xml")
public class UploaderDicomIdentifierPlugin {

	/** The logger. */
	public static Logger logger = Logger.getLogger(UploaderDicomIdentifierPlugin.class);


    /**
     * Instantiates a new SCP Dicom routing plugin
     */
    public UploaderDicomIdentifierPlugin() {
        logger.info("Configuring SCP Dicom routing plugin");
    }
    
}
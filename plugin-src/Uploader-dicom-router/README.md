## Macquarie Univerisity Custom DICOM SCP Routing Plugin

Plugin for XNAT (1.7.4) to do custom DICOM SCP routing.

# Building/Installing:
To build use the command
```
./gradlew clean jar
```
The produced jar file is placed in `/data/xnat-home/plugins`.
To install, restart tomcat and it will appear in the list of installed plugins if all went well.

# About/Usage:

This plugin was designed to read the project description from DICOM files and place them in the correct project automatically.
Much discussion leading to the development occurred [here](https://groups.google.com/forum/#!topic/xnat_discussion/0G86WPk_dXg).

While this plugin contains code specifically for the machines and descriptions used by us, I hope that the code is clear enough/commented well enough that anyone wishing to do something similar can use this as a template for their own code.

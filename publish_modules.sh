. ./common.sh

#Nexus rest api taken from 
#https://support.sonatype.com/entries/22189106-How-can-I-programatically-upload-an-artifact-into-Nexus-

#List and parse module versions
librarian-puppet show

#Verify each module has a metadata.json

#Tar up each module

#Upload module with curl

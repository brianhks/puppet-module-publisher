. ./common.sh

#Nexus rest api taken from 
#https://support.sonatype.com/entries/22189106-How-can-I-programatically-upload-an-artifact-into-Nexus-

#List and parse module versions
MODULES=`librarian-puppet show`

#Check for metadata.json
while read -r line; do
	module=`echo $line | cut -d ' ' -f 1 | cut -d '-' -f 2`
	if [ ! -e "modules/$module/metadata.json" ]
	then
		echo >&2 "Module $module is missing a metadata.json file, you must add one before uploading."
		exit 1;
	fi
done <<< "$MODULES"

#Verify each module has a metadata.json

#Tar up each module

#Upload module with curl

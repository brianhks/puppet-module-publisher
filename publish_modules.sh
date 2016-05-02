SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. $SCRIPT_DIR/common.sh

#Nexus rest api taken from 
#https://support.sonatype.com/entries/22189106-How-can-I-programatically-upload-an-artifact-into-Nexus-

if [ -z "$1" ]; then
	#List and parse module versions
	MODULES=`librarian-puppet show`
else
	MODULES=$1
fi


#Verify each module has a metadata.json
while read -r line; do
	module=`echo $line | cut -d ' ' -f 1 | cut -d '-' -f 2`
	if [ ! -e "modules/$module/metadata.json" ]
	then
		echo >&2 "Module $module is missing a metadata.json file, you must add one before uploading."
		exit 1;
	fi
done <<< "$MODULES"

#Tar up each module
while read -r line; do
	module=`echo $line | cut -d ' ' -f 1 | cut -d '-' -f 2`
	group=`echo $line | cut -d ' ' -f 1 | cut -d '-' -f 1`
	version=`echo $line | cut -d ' ' -f 2 | tail -c +2 | head -c -2`
	archive_name="$module-$version"
	if [ -e "modules/$archive_name.tar.gz" ]
	then
		rm modules/$archive_name.tar.gz
	fi
	#Have to rename the folder to match what should be in the archive
	mv modules/$module modules/$group-$module-$version
	tar -C modules -cf modules/$archive_name.tar $group-$module-$version
	#Rename back
	mv modules/$group-$module-$version modules/$module
	gzip modules/$archive_name.tar
	#Generate checksums
	md5sum modules/$archive_name.tar.gz > modules/$archive_name.tar.gz.md5
	sha1sum modules/$archive_name.tar.gz > modules/$archive_name.tar.gz.sha1
done <<< "$MODULES"


#Upload module with curl
while read -r line; do
	module=`echo $line | cut -d ' ' -f 1 | cut -d '-' -f 2`
	group=`echo $line | cut -d ' ' -f 1 | cut -d '-' -f 1`
	version=`echo $line | cut -d ' ' -f 2 | tail -c +2 | head -c -2`
	archive_name="$module-$version.tar.gz"
	
	curl -u $NEXUS_USER:$NEXUS_PASSWORD --upload-file modules/$archive_name  $NEXUS_URL/nexus/content/repositories/$NEXUS_REPOSITORY/$group/$module/$version/$module-$version.tar.gz
	curl -u $NEXUS_USER:$NEXUS_PASSWORD --upload-file modules/$archive_name.md5  $NEXUS_URL/nexus/content/repositories/$NEXUS_REPOSITORY/$group/$module/$version/$module-$version.tar.gz.md5
	curl -u $NEXUS_USER:$NEXUS_PASSWORD --upload-file modules/$archive_name.sha1  $NEXUS_URL/nexus/content/repositories/$NEXUS_REPOSITORY/$group/$module/$version/$module-$version.tar.gz.sha1
done <<< "$MODULES"

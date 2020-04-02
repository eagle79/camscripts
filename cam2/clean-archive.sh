#!/bin/bash
set -e

#SCRIPT CONFIGURATION
#Set this to the directory containing the uploaded files for the camera
HOMEDIR=/home/pi/Documents/repos/camscripts/cam2/AMC018A7_757298
#Set this to the number of days to keep archived, including the current date
ARCHIVE_DAYS=2

#FUNCTIONS
delete_archive_dir () {
	#Delete the specified directory
	rm -rf "${HOMEDIR}/${1}"
}

reorg_archive_dir () {
	#Move all MP4 files to the top of the subdirectory
	find "${HOMEDIR}/${1}" -mindepth 2 -type f -name '*.mp4' -exec mv {} "${HOMEDIR}/${1}" \;

	#Delete everything not in the top of the subdirectory
	find "${HOMEDIR}/${1}" -mindepth 1 -maxdepth 1 -type d -exec rm -rf {} \;
}

#MAIN SCRIPT
cd $HOMEDIR

CURR_DATE_STR=$(date --iso-8601=date)
LIMIT_DATE_STR=$(date --date="-${ARCHIVE_DAYS} days" --iso-8601=date)

echo "Cleaning cam2 archives..."
echo "Archives recorded prior to $LIMIT_DATE_STR will be removed."

#Loop through the subdirectories in the home directory
for DIR_NAME in */ ; do
	#If the subdirectoy is not formatted as an ISO-8601 date, we ignore it
	if [[ $DIR_NAME =~ [0-9]{4}-[0-9]{2}-[0-9]{2}/$ ]]; then
		if [[ "$DIR_NAME" < "$LIMIT_DATE_STR" ]]; then
			#Directories older than the limit date (see above) 
			# are deleted.
			echo "> [$DIR_NAME] - Deleting."
			delete_archive_dir $DIR_NAME
		else
			#If we aren't deleting it, we'll reorganize it, but 
			# only if it's not the current date.
			if [[ $DIR_NAME != "$CURR_DATE_STR/" ]]; then
				echo "> [$DIR_NAME] - Reorganizing."
				reorg_archive_dir $DIR_NAME
			else
				echo "> [$DIR_NAME] - Skipping (current date)"
			fi
		fi
	fi
done


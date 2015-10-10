#!/bin/sh
#################################################################
# Title: Demux MKV to MP4
# Author: tscrip <github.com/tscrip>
# Purpose: Loops though directory looking for MKV files. When
#      --> if finds an MKV, it uses avconv to demux video and
#	   --> audio into a MP4. Script deletes MKVs after converting
# ------------------------------------------------------------- #
# Change Log
# ------------------------------------------------------------- #
# tscrip -  9/20/15  - Script created
#################################################################
# Help
# ------------------------------------------------------------- #
# 
#################################################################

## Configuration ##
SCAN_DIRECTORY="/home/download_complete"
NEW_DIRECTORY="/home/processed"
DELETE_AFTER_CONVERT=true
MOVE_AFTER_CONVERTED=true

#Looking for MKV files
for mkv in "$SCAN_DIRECTORY/*.mkv"
do
	newFileName=${mkv%.*}
	avconv -i "$mkv" -codec copy "$new_file_name.mp4"

	#Checking to see if MP4 was created
	if [[ -e "$SCAN_DIRECTORY/$newFileName.mp4" ]]; then

		#Deleting MKV if flag is set
		if [[ $DELETE_AFTER_CONVERT -eq 'true' ]]; then
			rm "$SCAN_DIRECTORY/$mkv"
		fi

		#Moving MP4 to new directory if flag is set
		if [[ $MOVE_AFTER_CONVERTED -eq 'true' ]]; then
			mv "$SCAN_DIRECTORY/$newFileName.mp4 $NEW_DIRECTORY"
		fi
	fi
done
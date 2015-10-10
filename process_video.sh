#!/bin/bash
#################################################################
# Title: Process Videos
# Author: tscrip <github.com/tscrip>
# Purpose: Crawls through directory looking for media files
#     --> if it finds MP4, it moves the file to the completed dir
#     --> if it finds MKV, it will attempt to demux with avconv
#     --> if it finds *, it "should" kick off a hanbrake conversion
# ------------------------------------------------------------- #
# Change Log
# ------------------------------------------------------------- #
# tscrip -  10/1/15  - Script created
#################################################################
# Help
# ------------------------------------------------------------- #
# 
#################################################################

DOWNLOAD_DIRECTORY="/home/download_complete"
CONVERT_COMPLETE="/home/download_complete"
PROCESSED_DIRECTORY="/home/processed"
LOG_FILE="/home/scripts/process_video.log"

# Enables directories with spaces
IFS=$'\n'

# Writing header
printf "###################################\n### Started $(data) ###\n###################################\n"

# Looping throug download directory
for path in `ls "$DOWNLOAD_DIRECTORY/"`
do
  # Checking if $path is directory
  if [ -d "$DOWNLOAD_DIRECTORY/$path" ]; then
    echo "Dir: "$path"" >> $LOG_FILE
    
    # Looping through directory
    for file in `ls "$DOWNLOAD_DIRECTORY/$path"`
      do
        # Checking if file is MP4
        if [[ ${file: -4} == ".mp4" || ${file: -4} == ".m4v" ]]; then
          # Found MP4 file
          echo "MP4: $file" >> $LOG_FILE
          
          # Moving file
          mv "$DOWNLOAD_DIRECTORY/$path/$file" "$PROCESSED_DIRECTORY" 

        # Checking if file is MKV
        elif [[ ${file: -4} == ".mkv" ]]; then
          # File has MKV extension
          echo "MKV: $file" >> $LOG_FILE
           
          # Creating new file name
          newFileName=${file%.*}

          # Demuxing file
          avconv -i "$DOWNLOAD_DIRECTORY/$path/$file" -codec copy "$CONVERT_COMPLETE/$newFileName.mp4"
           
          # Moving demuxed file to processed directory
          mv "$DOWNLOAD_DIRECTORY/$path/$newFileName" "$PROCESSED_DIRECTORY"
          
          # Removing MKV after demux
          rm "$DOWNLOAD_DIRECTORY/$path/$file"

        elif [[ ${file: -4} == ".avi" || ${file: -4} == ".flv" || ${file: -4} == ".wmv" ]]; then
          # File has either wmv/flv/avi
          echo "WMV/FLV/AVI: $file" >> $LOG_FILE

          # Creating new file name
          newFileName=${file%.*}

          # Moving file to root directory
          mv "$DOWNLOAD_DIRECTORY/$path/$file" "$DOWNLOAD_DIRECTORY"

          # Converting file via Handbrake
          # HandBrakeCLI -i "$DOWNLOAD_DIRECTORY/$path/$file" -o "$CONVERT_COMPLETE/$newFileName.mp4" -e x264  -q 20.0 -r 30 --pfr  -a 1,1 -E faac,copy:ac3 -B 160,160 -6 dpl2,none -R Auto,Auto -D 0.0,0.0 --audio-copy-mask aac,ac3,dtshd,dts,mp3 --audio-fallback ffac3 -f mp4 -4 -X 1280 -Y 720 --loose-anamorphic --modulus 2 -m --x264-preset medium --h264-profile high --h264-level 3.1 

          # Checking if new file exists
          # if [ -f "$CONVERT_COMPLETE/$newFileName.mp4" ]; then
            # File exists

            # Removing file
            # rm "$DOWNLOAD_DIRECTORY/$path/$file"

            # Moving MP4 file
            # mv "$CONVERT_COMPLETE/$newFileName.mp4" "$PROCESSED_DIRECTORY"
          # else
            # File does not exist
            # echo "Conversion of $file failed\n"
          # fi
        else
          # File does not have MP4,MKV,AVI,FLV,WMV extension

          # Removing file
          rm "$DOWNLOAD_DIRECTORY/$path/$file"
          echo "Invalid File Type: ${file: 4}" >> $LOG_FILE
        fi
      done
      
      echo "Removing directory: $DOWNLOAD_DIRECTORY/$path" >> $LOG_FILE
      # Deleting directory
      rm -rf "$DOWNLOAD_DIRECTORY/$path"   

  elif [ -f "$DOWNLOAD_DIRECTORY/$path" ]; then
    # echo "File: "$DOWNLOAD_DIRECTORY/$path""

    # Checking if file is MP4
    if [[ ${path: -4} == ".mp4" || ${path: -4} == ".m4v" ]]; then
      # Found MP4 file
      echo "MP4: $path"  >> $LOG_FILE
      
      # Moving file
      mv "$DOWNLOAD_DIRECTORY/$path" "$PROCESSED_DIRECTORY" 

    # Checking if file is MKV
    elif [[ ${path: -4} == ".mkv" ]]; then
      # File has MKV extension
      echo "MKV: $path" >> $LOG_FILE
       
      # Creating new file name
      newFileName=${path%.*}

      # Demuxing file
      avconv -i "$DOWNLOAD_DIRECTORY/$path" -codec copy "$CONVERT_COMPLETE/$newFileName.mp4"
       
      # Moving demuxed file to processed directory
      mv "$DOWNLOAD_DIRECTORY/$newFileName" "$PROCESSED_DIRECTORY"
      
      # Removing MKV after demux
      rm "$DOWNLOAD_DIRECTORY/$path"

    elif [[ ${path: -4} == ".avi" || ${path: -4} == ".flv" || ${path: -4} == ".wmv" ]]; then
      # File has either wmv/flv/avi
      echo "WMV/FLV/AVI: $path" >> $LOG_FILE

      # Creating new file name
      newFileName=${path%.*}

      # Moving file to root directory
      mv "$DOWNLOAD_DIRECTORY/$path" "$DOWNLOAD_DIRECTORY"

      # Converting file via Handbrake
      # HandBrakeCLI -i "$DOWNLOAD_DIRECTORY/$path" -o "$CONVERT_COMPLETE/$newFileName.mp4" -e x264  -q 20.0 -r 30 --pfr  -a 1,1 -E faac,copy:ac3 -B 160,160 -6 dpl2,none -R Auto,Auto -D 0.0,0.0 --audio-copy-mask aac,ac3,dtshd,dts,mp3 --audio-fallback ffac3 -f mp4 -4 -X 1280 -Y 720 --loose-anamorphic --modulus 2 -m --x264-preset medium --h264-profile high --h264-level 3.1 
      
      # Checking if new file exists
      # if [ -f "$CONVERT_COMPLETE/$newFileName.mp4" ]; then
        # File exists

        # Removing file
        # rm "$DOWNLOAD_DIRECTORY/$path"

        # Moving MP4 file
        # mv "$CONVERT_COMPLETE/$newFileName.mp4" "$PROCESSED_DIRECTORY"
      # else
        # File does not exist
        # echo "Conversion of $file failed\n"
      # fi
    else
      # File does not have MP4,MKV,AVI,FLV,WMV extension

      # Removing file
      rm "$DOWNLOAD_DIRECTORY/$path"
      echo "Invalid File Type" >> $LOG_FILE

    fi
  fi
done

# Cleaning up .ignore files from processed directory
rm $PROCESSED_DIRECTORY/*.ignore

# Writing Footer
printf "###################################\n### Finished $(date) ###\n###################################\n"

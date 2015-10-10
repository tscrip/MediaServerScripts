#!/bin/bash
#################################################################
# Title: Complete Torrent Script
# Author: rubikcubic
# Purpose: Is triggered by Transmission when a torrent is complete
#	   --> Connects via RPC and removes completed torrents
# ------------------------------------------------------------- #
# Change Log
# ------------------------------------------------------------- #
# rubikcubic -  7/04/14 - Script created
# tscrip     -  9/13/15 - Updated comments, variables
#################################################################
# Help
# ------------------------------------------------------------- #
#
#################################################################

#Defining constants
USERNAME="root"
PASSWORD="password"
PORT="9091"
CONNECTION_STRING="$PORT --auth $USERNAME:$PASSWORD"

#Making RPC call to transmission to get all torrents
#Using sed to delete first line, last line, and leading spaces from output
#Using cut to get first field from each line
TORRENTLIST=`transmission-remote $CONNECTION_STRING --list | sed -e '1d;$d;s/^ *//' | cut --only-delimited --delimiter=" "  --fields=1`

#Looping through torrents in list
for TORRENTID in $TORRENTLIST
do
    #Checking if torrent download is completed
    DL_COMPLETED=`transmission-remote $CONNECTION_STRING --torrent $TORRENTID --info | grep "Percent Done: 100%"`

    #Checking if torrent has a stopped state
    STATE_STOPPED=`transmission-remote $CONNECTION_STRING --torrent $TORRENTID --info | grep "State: Seeding\|Stopped\|Finished\|Idle"`

    #Checking if torrent is "Stopped", "Finished", or "Idle and is downloaded 100%"
    if [ "$DL_COMPLETED" ] && [ "$STATE_STOPPED" ]; then
        #Torrent is complete

        #Removing torrent from transmission
        transmission-remote $CONNECTION_STRING --torrent $TORRENTID --remove
    fi
done

# Calling process video script
/opt/scripts/process_video.sh

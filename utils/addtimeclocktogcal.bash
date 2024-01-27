#!/bin/bash
set -e

timeclockfile="${1}"
gcalendarname="${2}"
applyarg="${3}"

if [ -z "${timeclockfile}" ] || [ -z "${gcalendarname}" ]; then

	echo "         USAGE:  addtimeclocktogcal [ timeclockfilepath] [ calendarname ] [optional '--actually-add-to-google-calendar' ]"
	echo "      EXAMPLE1:  addtimeclocktogcal ~/missingfromgoogle.timeclock TimeClockPo"
	echo "      EXAMPLE2:  addtimeclocktogcal ~/missingfromgoogle.timeclock TimeClockPo --actually-add-to-google-calendar"
	echo ""
	echo "This script adds ALL entries from a timeclock file to google calendar."
	echo "For instance you can split up your timeclock into entries that never made it to google, and then use this to add them."
	echo "Be careful, this is a one time operation..."
	echo ""
	exit 1
fi
if [ ! -f "${timeclockfile}" ]; then
	echo "ERROR: ${timeclockfile} does not exist."
	exit 1
fi


function addtogooglecalendar() {
	#gcalcli add --title="POISM:dev" --description="OK this is a description passed from cli..." --when="2024-01-25 15:00:00" --duration=30
	if [ "${applyarg}" == "--actually-add-to-google-calendar" ]; then
		echo "APPLY: gcalcli add --calendar=\"${gcalendarname}\" --title=\"${1}\" --description=\"${2}\" --when=\"${3}\" --duration=\"${4}\" --noprompt"
		gcalcli add --calendar="${gcalendarname}" --title="${1}" --description="${2}" --when="${3}" --duration="${4}" --noprompt
		if [ $? -eq 0 ]; then
			echo "OK: Added to google calendar ${gcalendarname}"
		else
			echo "ERROR: Failed to add to google calendar ${gcalendarname}"
		fi
	else
		echo "DRY-RUN: gcalcli add --calendar=\"${gcalendarname}\" --title=\"${1}\" --description=\"${2}\" --when=\"${3}\" --duration=\"${4}\" --noprompt"
	fi

}


# GO:
while IFS="" read -r p || [ -n "$p" ]; do

	thetime=$( echo "${p}" | grep -o '[0-9][0-9][0-9][0-9]\/[0-9][0-9]\/[0-9][0-9] [0-9][0-9]:[0-9][0-9]:[0-9][0-9]' )
	if [[ "${p}" =~ ^"i " ]]; then
		#echo "IN: ${p}"
		starttime="${thetime}"
		titleanddesc=$( echo "${p}" | cut -c 23- )
		title="${titleanddesc%  *}"
		description="${titleanddesc#*  }"
	elif [[ "${p}" =~ ^"o " ]]; then
		#echo "OUT: ${p}"
		endtime="${thetime}"
		startsec=$(date --date "${starttime}" +%s)
		endsec=$(date --date "${endtime}" +%s)
		duration=$(( ${endsec} - ${startsec} ))
		clockminonly=$(( ${duration} / 60))
		addtogooglecalendar "${title}" "${description}" "${starttime}" "${clockminonly}"
		# RESET:
		startime=""
		endtime=""
		title=""
		titleanddesc=""
		description=""
	else
		echo "FAIL: ${p}"
	fi
done < ${timeclockfile}

if [ "${applyarg}" == "--actually-add-to-google-calendar" ]; then
	echo "THE ABOVE WAS ADDED TO YOUR CALENDAR ${gcalendarname}!"
else
	echo "THE ABOVE WAS ONLY A DRY RUN!"
	echo "If it looked good, rerun last command with --actually-add-to-google-calendar appended to the end."
fi

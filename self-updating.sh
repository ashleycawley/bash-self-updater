#!/bin/bash

# Variables

# This stores script-name.sh inside the variable $SCRIPTNAME
SCRIPTNAME=`basename "$0"`

# Storing the full path and filename in a variable:
FULLSCRIPTPATH="`pwd`/$SCRIPTNAME"

UPDATE_SOURCE="https://raw.githubusercontent.com/ashleycawley/bash-self-updater/master/self-updating.sh"

# URL to check to see if update should proceed
TWOFA="http://status.ashleycawley.co.uk/update-2fa.txt"

# Scripts current md5sum hash
MY_MD5=(`md5sum $FULLSCRIPTPATH`)

# Downloads script from source URL, extracts md5sum and then deletes the temporary file
ONLINE_MD5=(`wget -q -O /tmp/testing.md5 $UPDATE_SOURCE; md5sum /tmp/testing.md5 | awk '{print $1}'; rm -f /tmp/testing.md5`)

# Functions

function MD5_COMPARISON {
    echo "Script's current md5: $MY_MD5"
    echo "Script's online md5 : $ONLINE_MD5"
    echo
}

# Script

MD5_COMPARISON

echo -e "Comparison check: \c"

if [ $MY_MD5 != $ONLINE_MD5 ]
then
    echo "Local & Remote md5sums are not equal - Version Mismatch!"
    echo

    if [ `wget -q -O /tmp/update-2fa.txt http://status.ashleycawley.co.uk/update-2fa.txt; cat /tmp/update-2fa.txt` == "UPDATE" ]
    then
        echo "Update server acknowledges update cycle."
        echo "Downloading newer version from $UPDATE_SOURCE"
        wget -q -O $FULLSCRIPTPATH $UPDATE_SOURCE
        chmod +x $FULLSCRIPTPATH
        echo
    else
    echo "Update server has not acknowledged that an updated version has been released - No update will be performed."
    fi
    echo "Performing another md5sum check local vs remote..."
    # Scripts current md5sum hash
    MY_MD5=(`md5sum $FULLSCRIPTPATH`)
    # Downloads script from source URL, extracts md5sum and then deletes the temporary file
    ONLINE_MD5=(`wget -q -O /tmp/testing.md5 $UPDATE_SOURCE; md5sum /tmp/testing.md5 | awk '{print $1}'; rm -f /tmp/testing.md5`)

    MD5_COMPARISON
else
    echo "Local & Remote md5sum are equal - This script is up to date."
fi
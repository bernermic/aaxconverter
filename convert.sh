#!/bin/bash -e

sourcefile=$1
targetfile=$2
activation=xxx
path=`pwd`

[ $activation = "xxx" ] && ( echo "please insert your personal activation code"; exit 1 )

help()
{
    echo "Usage: `basename $0` [sourcefile targetfile]"
    exit 0
}

metadata()
{
    cd "$path"
    ffmpeg -activation_bytes "$activation" -i "$sourcefile" -f ffmetadata "$targetfile.meta"
}

convert()
{
    cd "$path"
    [ -s "$targetfile.meta" ] && ffmpeg -activation_bytes "$activation" -i "$sourcefile" -i "$targetfile.meta" -map_metadata 1 -codec copy "$targetfile" || echo "No metadata found"
}

[ -z $sourcefile ] || [ -z $targetfile ] && help
metadata
convert

echo
echo
echo "-------------------------------"
echo "Done - enjoy your audio $targetfile"
echo "-------------------------------"

#!/bin/sh -e

sourcefile=$1
targetfile=$2
activation=xxx
[ -n "$3" ] && activation=$3
path=$(pwd) 

[ "$activation" = "xxx" ] && ( echo "please set your personal activation code as activation=<yourcode>"; exit 1 )

help()
{
    echo "Usage: `basename $0` sourcefile targetfile [activationcode]"
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
    [ -s "$targetfile.meta" ] && ffmpeg -activation_bytes "$activation" -i "$sourcefile" -i "$targetfile.meta" -map_metadata 1 -codec copy "$targetfile.m4a" || echo "No metadata found"
    rm "$targetfile.meta"
}

[ -z "$sourcefile" ] || [ -z "$targetfile" ] && help
[ ! -f "$sourcefile" ] && ( echo "File $sourcefile not found. Please check you gave the correct parameter"; exit 1 )
[ -d "$(dirname $sourcefile)" ] && path=$(dirname $sourcefile) 
metadata
convert

echo
echo
echo "-------------------------------"
echo "Done - enjoy your audio $targetfile"
echo "-------------------------------"

#!/bin/bash
checkDir () {
	if [ ! -d $1 ]
	then
		echo "Directory: $1 does not exist"
		exit 1
	fi
}
case "$1" in
	-d)
		mode=1
		;;
	-l)
		mode=2
		;;
	-c) mode=3
		;;
	*)
		echo "Usage: Avaliable flag {-d|-l|-c}"
		exit 1
esac

if [ ! -f $2 ] #$2 is archive file path
then
	echo "File doesn't exist"
	exit 1
else
	archiveFile=$(readlink -f $2)	
fi

tar -a -xf $archiveFile

rawFileName=$(basename "$2")
filename="${rawFileName%.*.*}"

archiveFileDir=$(pwd)/$filename

checkDir $archiveFileDir

if [ ! -f "$archiveFileDir/record" ] #$2 is archive file path
then
	echo "Record file doesn't exist"
	exit 1
fi

i=0
while IFS= read line
do
    if [ $i -eq 1 ]
	then
		originalFolder=$(basename $line)
		originalFileMask=$line/
	fi

	if [ $i -gt 1 ]
	then 
		if [[ $line == *"FileName: "* ]]
		then
			prefix="FileName: "
			dupeFileName=${line#$prefix}
			echo $dupeFileName
		else
			case "$mode" in
				1)
					;;
				2)
					linkFileName=$archiveFileDir/$originalFolder/${line#$originalFileMask}
					ln -s $line $linkFileName
					;;
				3)
					linkFileName=$archiveFileDir/$originalFolder/${line#$originalFileMask}
					cp $line $linkFileName
			esac
		fi
	fi
	i=$((i+1))
done <"$archiveFileDir/record"

#Read record file








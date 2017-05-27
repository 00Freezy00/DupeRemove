#!/bin/bash
checkDir () {
	if [ ! -d $1 ]
	then
		echo "Directory: $1 does not exist"
		exit 1
	fi
}

checkDupe () {
	local recordDir="$1/record"
	echo "#Record of duplicate files" > $recordDir
	echo "$2" >> $recordDir
	while read -r line
	do
		($scriptDir/dupeDetect.pl $line) >> $recordDir
	done < <(fdupes -r1 $2)
}

scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

mode=0
if [ $# -eq 2 ] # 2 Arguments
then
	checkDir $2
	inputDir=$(readlink -f $2)
	outputDir=$(readlink -f $1)
else
	if [ $# -eq 3 ] # 3 Arguments
	then
		case "$1" in
			-g)
				mode=1
				;;
			-b)
				mode=2
				;;
			-c)
				mode=3
				;;
			*)
				echo "Usage: Avaliable flag {-g|-b|-c}"
				exit 1
		esac
		checkDir $3
		inputDir=$(readlink -f $3)
		outputDir=$(readlink -f $2)
	else
		echo "dear [options] outfile indir"
		exit 1
	fi
fi

if [[ $outputDir == *$inputDir* ]]; then #check sub string
	echo "Output file is inside of input Directory"
  	exit 1
fi

mkdir $outputDir

checkDupe $outputDir $inputDir

cp -r $inputDir $outputDir/ >> /dev/null

fdupes -rdNfqn $outputDir/ >> /dev/null

fileName=$(basename $outputDir)

cd $outputDir/../
tar -cvf $fileName.tar ./$fileName
rm -R $outputDir

case "$mode" in
	0)
		;;
	1)
		gzip $fileName.tar
		;;
	2)
		bzip2 $fileName.tar
		;;
	3)
		compress -f $fileName.tar
		;;
	*)
		exit 1
esac
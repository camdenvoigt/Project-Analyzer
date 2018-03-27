#!/bin/bash

## Global Variables

outputFolder="/usr/local/var/project-analyzer/tmp/"
rulest="/usr/local/var/project-analyzer/resources/Ruleset.xml"
pmdFilter="/usr/local/var/project-analyzer/resources/pmd-filter.xslt"
cpdFilter="/usr/local/var/project-analyzer/resources/cpd-filter.xslt"
clocFilter="/usr/local/var/project-analyzer/resources/cloc-filter.xslt"

projectURL=""
projectName=""
projectLocation=""
pmdOut=""
cpdOut=""
clocOut=""
report=""

## Read and save command line arguments

while getopts ":p:" opt; 
do
	case $opt in
		p)
			projectURL=$OPTARG
			projectName=${projectURL:19}
			projectName=${projectName//\//_}
			projectLocation="/usr/local/var/project-analyzer/$projectName"
			pmdOut="$outputFolder$projectName-pmd.xml"
			cpdOut="$outputFolder$projectName-cpd.xml"
			clocOut="$outputFolder$projectName-cloc.xml"
			report="$outputFolder$projectName-report.html"
			;;
		?) 
			echo "Invalid option: -$OPTARG" >&2
			exit 1
			;;
		:)
			echo "Option -$OPTARG requires an argument." >&2
      		exit 1
      		;;
	esac
done

## Clone project to project location
echo "Cloning From $projectURL..."
git clone --quiet $projectURL $projectLocation

## Run Different Tools

### Run PMD
echo "Running PMD..."
pmd.sh pmd -d $projectLocation -f xslt -r $report -R $rulest -property xsltFilename=$pmdFilter 2> /dev/null

### Run CPD
echo "Running CPD.."
pmd.sh cpd --minimum-tokens 100 --files $projectLocation --format xml > $cpdOut

### Run CLOC
echo "Running Code Metrics..."
cloc --xml --quiet --report-file=$clocOut $projectLocation 2> /dev/null

## Compile Report
echo "Compiling Report..."
### XSLT on cpd report
saxon -s:$cpdOut -xsl:$cpdFilter >> $report

### XSLT on cloc report
saxon -s:$clocOut -xsl:$clocFilter >> $report

## Remove Project
echo "Removing Project..."
rm -rf $projectLocation/* $projectLocation/.* 2> /dev/null

rm -r $projectLocation

mv $report $HOME/Desktop

echo "Output File Located in ~/Desktop"

rm $outputFolder*

echo "Done."
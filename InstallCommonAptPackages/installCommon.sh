#!/bin/bash
# This script will read package names from a text file and 
# use apt-get to install them

Red='\033[0;31m'
Green='\033[0;32m'
Yellow='\033[1;33m'
NoColor='\033[0m' # No Color

# Print out the useage/help of this script
function PrintHelp 
{ 
    echo ""
    echo "Useage:   ./installCommon.sh [OPTIONS]"
    echo ""
    echo "Commands"
    echo "  -h      Help                    Print this help message"
    echo "  -d      Dry run                 If set then this script will do a dry run and only print out the packages, not install them."
    echo "  -f      Package file            Specifiy the file that has the list of packages to install in it"
    exit 1;
}

isDryRun=false
packageFile=./packagesToInstall.txt

# Iterate the optional args!
while getopts "f:d" flag
do
     case $flag in
        f)
            packageFile=$OPTARG
            ;;
        d)
            isDryRun=true
            ;;
        *)
            PrintHelp
            ;;
     esac
     
done

printf "\nAttempting to install apt-get packages from '$packageFile'\n\n"

# If it's a dry run, then just echo what xargs command would run
if [ "$isDryRun" = true ] ; then
    printf "${Yellow}\nThis is a dry run! No packages will be installed!${NoColor}\n\n"
    < $packageFile xargs echo apt-get install -y
# Otherwise we want to actually install the packages
else
    printf "${Green}Starting install...\n\n${NoColor}"
    < $packageFile xargs echo apt-get install -y
    printf "\n\n"
    < $packageFile xargs sudo apt-get install -y
fi


if [ $? -eq 0 ]; then
   printf "\n${Green}Successfully installed all packages!${NoColor}\n\n"
else
   printf "\n${Red} Uh oh!! Failed to install all packages! Error code $? ${NoColor}\n\n"
fi
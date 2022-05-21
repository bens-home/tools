#!/bin/bash
# This is a script that I can use to automatically queue episodes
# on a DVD for transcoding to a Plex-friendly file format

Red='\033[0;31m'
Green='\033[0;32m'
Yellow='\033[1;33m'
LightBlue='\033[1;34m'
NoColor='\033[0m'

# Print out the useage/help of this script
function PrintHelp 
{ 
    echo ""
    echo "Useage:   ./rip.sh [OPTIONS]"
    echo ""
    echo "Commands"
    echo "  -h      Help                    Print this help message"
    echo "  -d      Destination Folder      The directory to place the transcoded video files"
    exit 1;
}

function EnsureSuccess
{
    if [ $? -eq 0 ]; then
        printf "\n${Green}Success!${NoColor}\n"
    else
        printf "\n${Red} Uh oh!! Failed. Error code $? ${NoColor}\n\n"
        exit 1;
    fi
}

disk=/dev/sr0
destinationDir="/media/BigData/Media/Series/$seriesName"
scratchDir="~/scratch"
episodeCount=32
seriesName="TvShowName"
seasonNum=1

# Iterate the args!
while getopts "f:d" flag
do
     case $flag in
        f)
            disk=$OPTARG
            ;;
        d)
            destinationDir=$OPTARG
            ;;
        s)
            scratchDir=$OPTARG
            ;;
        e)
            episodeCount=$OPTARG
            ;;
        n)
            seriesName=$OPTARG
            ;;
        N)
            seasonNum=$OPTARG
            ;;
        *)
            PrintHelp
            ;;
     esac 
done

printf "${Green}Ripping DVD with the following options:\n\n${NoColor}"
printf "\tSeries Title:      \t$seriesName\n"
printf "\tNumber of Episodes:\t$episodeCount\n"
printf "\tFrom Disk:         \t$disk\n"
printf "\tScratch Dir:       \t$scratchDir\n"
printf "\tDestination Dir:   \t$destinationDir\n\n"


# Make the scratch dir
printf "${LightBlue}Creating the scratch direcotry '$scratchDir' ...\n${NoColor}"
mkdir -p $scratchDir
EnsureSuccess

# For each episode that we have specified, queue it for transcoding
# on handbrake

offset=0
for c in $(seq 1 1 $episodeCount)
do
    #ep=`printf "%02.f" $(( ($disk-1)*$episodeCount+$c ))`
    #fn="$scratchDir/$seriesName ${series}x$ep.mp4"
    outFileName="${seriesName}_S${seasonNum}_E$c"
    outDir="$scratchDir/$seriesName/Season_$seasonNum"
    fullDestPath="$outDir/$outFileName"
    printf "Transcoding episode $c to $fullDestPath"
    # TODO: figure how to use handbrake CLI, i don't really get it yet
#     /home/oli/hb/HandBrakeCLI -S 200 -Z Television -a 1 -i /dev/sr0 -o "$fn" -t $(($c + $offset))
    EnsureSuccess
done

# move the files from the scratch dir to the final destination
printf "\n\n${LightBlue}Moving from scratch location '$scratchDir' to '$destinationDir'${NoColor}"
#mv $scratchDir/* "$destinationDir"
EnsureSuccess


# Maybe eject the disk? idk probably not
# eject
# sleep 2
# eject

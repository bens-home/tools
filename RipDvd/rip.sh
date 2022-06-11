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

# Prints out success status if the previous command worked. Exits if it failed
function EnsureSuccess
{
    if [ $? -eq 0 ]; then
        printf "\n\t${Green}Success!${NoColor}\n"
    else
        printf "\n${Red} Uh oh!! Failed. Error code $? ${NoColor}\n\n"
        exit 1;
    fi
}

disk=/dev/sr0
destinationDir="/media/BigData/Media/Series"
scratchDir="./scratch"
episodeCount=32
seriesName="TvShowName"
seasonNum=1

# Iterate the args!
while getopts "f:d:s:e:n:z:" flag
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
        z)
            seasonNum=$OPTARG
            ;;
        *)
            PrintHelp
            ;;
     esac 
done

printf "\n${LightBlue}Ripping DVD with the following options:\n\n${NoColor}"
printf "\tSeries Title:      \t$seriesName\n"
printf "\tSeason Number:     \t$seasonNum\n"
printf "\tNumber of Episodes:\t$episodeCount\n"
printf "\tFrom Disk:         \t$disk\n"
printf "\tScratch Dir:       \t$scratchDir\n"
printf "\tDestination Dir:   \t$destinationDir\n\n"


# Make the scratch dir, which is where the episodes will be transcoded too first
printf "${LightBlue}Creating the scratch directory ${Yellow}$scratchDir${NoColor}..."
mkdir -p $scratchDir
EnsureSuccess

# For each episode that we have specified, queue it for transcoding
# on handbrake

offset=0

# We should probably change this to "For each .VOB file in the dir"... idk why i did episode numbers
for c in $(seq 1 1 $episodeCount)
do
    # The name of the file is Series Season Num Episode Num
    outFileName="${seriesName}_S${seasonNum}_E$c.mp4"
    # Output to the scratch directory per season
    outDir="$scratchDir/$seriesName/Season_$seasonNum"
    fullDestPath="$outDir/$outFileName"

    printf "Transcoding episode $c to ${Yellow}$fullDestPath${NoColor}...\n\t"
    # TODO: figure how to use handbrake CLI, i don't really get it yet
    #fr.handbrake.HandBrakeCLI -S 200 -Z "General/Fast 1080p30" -a 1 -i $disk -o "$fullDestPath" -t $(($c + $offset))
    #EnsureSuccess
done

# The final destination that we want the files in is the given destination directory + the series name
finalDestination=${destinationDir}/${seriesName}

# Create the destination directory if it doesn't exist
printf "\n${LightBlue}Creating destination directory ${Yellow}$finalDestination${NoColor}..."
mkdir -p $finalDestination
EnsureSuccess

# move the files from the scratch dir to the final destination
printf "${LightBlue}Moving from scratch location ${Yellow}$scratchDir${LightBlue} to ${Yellow}$finalDestination${NoColor}..."
mv $scratchDir/* "$finalDestination"
EnsureSuccess
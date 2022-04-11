#!/bin/bash
# Install ZSH and set it as the default shell for this user

Red='\033[0;31m'
Green='\033[0;32m'
LightBlue='\033[1;34m'
NoColor='\033[0m'

# Print out the useage/help of this script
function PrintHelp 
{ 
    printf "\nUseage:   ./installZsh.sh\n"
    printf "\n\tThis script will download the ZSH install script from their official GitHub and set it as the default shell for this user.\n\n"
    exit 1;
}

# Iterate the optional args to see if we need help
while getopts ":h" flag
do
     case $flag in
        *)
            PrintHelp
            ;;
     esac
done

# Links to the ZSH install script and their github
zshInstallScriptLink=https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh
zshSourceRepoLink=https://github.com/ohmyzsh/ohmyzsh

printf "\nDownloading ZSH from:${LightBlue} $zshInstallScriptLink ${NoColor}..."
printf "\n\tSee the ZSH GitHub for more info:${LightBlue} $zshSourceRepoLink ${NoColor}...\n\n"

# Download the install script and run it with the shell command to install it
sh -c "$(curl -fsSL $zshInstallScriptLink)"

if [ $? -eq 0 ]; then
    printf "${Green}Install successful!\n\n${NoColor}"
else
    printf "${Red}Uh oh! Failed to download the install script! Error code $?  \n\n${NoColor}"
    printf "\tExiting...${NoColor}\n\n"
    exit 2;
fi

printf "Attempting to set ZSH as default with ${LightBlue}chsh${NoColor}...\n\n"

# Set ZSH to the default shell on this user
chsh -s $(which zsh)

if [ $? -eq 0 ]; then
    printf "${Green}ZSH is now the default! You need to log out and log back in for it to take affect.\n\n${NoColor}"
else
    printf "${Red}Uh oh! Failed to set ZSH as the default! Error code $?  \n\n${NoColor}"
    printf "\tExiting...${NoColor}\n\n"
    exit 3;
fi
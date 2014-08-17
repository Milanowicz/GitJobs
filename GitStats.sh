#!/bin/bash
#########################################
## File: GitStats.sh                   ##
##                                     ##
## Check Git Server Stats and send it  ##
## via mail to an user                 ##
##                                     ##
## Script Version 0.0.9                ##
##                                     ##
#########################################

Time=$(date +%Y-%m-%d_%H%M)


#############################################################
#                       Shell Sctipt                        #
#############################################################

# Einlesen der Konfiguration
while read Line; do
    Line=${Line//=/ }
    Var=($Line)
    export ${Var[0]}=${Var[1]}
done < /home/git/local.conf

Subject="Git Repository Report from "$ServerName
InfoFile=$InfoDir"/"$ServerName"_GitStats_"$Time".txt"


# Verzeichnis pruefen
ls $InfoDir > /dev/null 2> /dev/null
if [ $? != 0 ]; then
    mkdir $InfoDir > /dev/null
    exit 1
fi


echo "###########################################################" >> $InfoFile
echo "                 Repository Report from $ServerName" >> $InfoFile
echo "###########################################################" >> $InfoFile

# Git
ls $RepoPath > /dev/null 2> /dev/null

if [ $? == 0 ]; then
    echo -e "\n\nGit Directory" >> $InfoFile
    du -h --max-depth 1 $RepoPath >> $InfoFile 2>> $InfoFile
fi


echo -e "\n\n" >> $InfoFile
echo "###########################################################" >> $InfoFile
echo "                 Protokoll Report" >> $InfoFile
echo "###########################################################" >> $InfoFile

echo -e "\n\nGit Log" >> $InfoFile
tail -n 20 $Log >> $InfoFile 2> /dev/null
echo -e "\n\nGit Error Log" >> $InfoFile
tail -n 20 $Error >> $InfoFile 2> /dev/null

#  Delete old files
find $InfoDir -mtime +30 -exec rm {} \;

# EMail versenden von den Sachen die passiert sind
mail -s "$Subject" $Receiver < $InfoFile
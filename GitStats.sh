#!/bin/bash
#########################################
## File: GitStats.sh                   ##
##                                     ##
## Check Git Server Stats and send it  ##
## via mail to an user                 ##
##                                     ##
## Script Version 0.0.91               ##
##                                     ##
#########################################

#############################################################
#                       Shell Sctipt                        #
#############################################################
Time=$(date +%Y-%m-%d_%H%M)

# Einlesen der Konfiguration
while read Line; do
    Line=${Line//=/ }
    Var=(${Line})
    export ${Var[0]}=${Var[1]}
done < local.conf

Subject="Git Repository Report from ${ServerName}"
InfoFile=${InfoDir}"/${ServerName}_GitStats_${Time}.txt"


# Check if git repository directory exists
ls ${RepoPath} > /dev/null 2> /dev/null

if [ $? == 0 ]; then

    # Check if dokumentation directory exists
    ls ${InfoDir} > /dev/null 2> /dev/null
    if [ $? != 0 ]; then
        mkdir ${InfoDir} > /dev/null
        if [ $? != 0 ]; then
            exit 1
        fi
    fi


    echo "###########################################################" >> ${InfoFile}
    echo "                 Repository Report from ${ServerName}" >> ${InfoFile}
    echo "###########################################################" >> ${InfoFile}


    echo -e "\n\nGit Directory:" >> ${InfoFile}

    find $1 -name '*.git' | while read Repo; do

        du -h --max-depth 0 ${RepoPath} >> ${InfoFile} 2>> ${InfoFile}

    done

    #  Delete old files
    find ${InfoDir} -mtime +30 -exec rm {} \;

    # EMail versenden von den Sachen die passiert sind
    mail -s "$Subject" ${Receiver} < ${InfoFile}

fi
#!/bin/bash
#########################################
## File: GitGarbageCollection.sh       ##
##                                     ##
## Garbage collection for all empty    ##
## objects references from repository  ##
##                                     ##
## Script Version 0.0.2                ##
##                                     ##
#########################################


#############################################################
#                       Shell Sctipt                        #
#############################################################
Time=$(date +%Y-%m-%d_%H%M)

# read config
while read Line; do
    Line=${Line//=/ }
    Var=(${Line})
    export ${Var[0]}=${Var[1]}
done < local.conf

Subject="Git Garbage Collection Report from "${ServerName}
InfoFile=${InfoDir}"/"${ServerName}"_GitGarbageCollection_"${Time}".txt"


# Verzeichnis pruefen
ls ${InfoDir} > /dev/null 2> /dev/null
if [ $? != 0 ]; then
    mkdir ${InfoDir} > /dev/null
    exit 1
fi

echo -e "\n\nGit Directory" >> ${InfoFile}
du -h --max-depth 1 $1 >> ${InfoFile} 2>> ${InfoFile}

# Find all Git Repositories
find $1 -name '*.git' | while read Repo; do

    cd "$Repo"
    echo "Processing Git Repository -> '$Repo'"

    echo -e "\n\n\tGit Repository: $RepoName\n" >> ${InfoFile}

    git gc >> ${InfoFile}

done

du -h --max-depth 1 $1 >> ${InfoFile} 2>> ${InfoFile}

#  Delete old files
find ${InfoDir} -mtime +30 -exec rm {} \;

# EMail versenden von den Sachen die passiert sind
mail -s "$Subject" ${Receiver} < ${InfoFile}
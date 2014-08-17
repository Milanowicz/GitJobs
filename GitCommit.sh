#!/bin/bash
#########################################
## File: GitCommit.sh                  ##
##                                     ##
## Get a overview from all commits     ##
## from every repostory that are       ##
## hosted on the server                ##
##                                     ##
## Script Version 0.0.2                ##
##                                     ##
#########################################


#############################################################
#                       Shell Sctipt                        #
#############################################################

# read config
while read Line; do
    Line=${Line//=/ }
    Var=($Line)
    export ${Var[0]}=${Var[1]}
done < /home/git/local.conf


# Check directory
ls $CommitPath > /dev/null 2> /dev/null
if [ $? != 0 ]; then
    mkdir $CommitPath > /dev/null
    exit 1
fi

rm $CommitPath"/*" > /dev/null 2> /dev/null

# Find all Git Repositories
find $RepoPath -name '*.git' | while read Repo; do

    cd "$Repo"
    echo "Processing Git Repository -> '$Repo'"

    RepoName=${Repo/$RepoPath/""}
    CommitFile=$CommitPath"/"$RepoName"CommitLog.txt"

    # Read Commits from the Git Repositories
    echo -e "\n\n\tGit Repository: $RepoName\n" >> $CommitFile

    git log --pretty=format:"%h - %an, %ad : %s" --graph >> $CommitFile

done
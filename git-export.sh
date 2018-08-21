#!/bin/sh
 
#
# USAGE: export.sh REPO_NAME BRANCH_NAME [DIRECTORY_NAME] [BITBUCKET_ACCOUNT_NAME]
#
#
 
BITBUCKET_ACCOUNT_NAME=fa-parmeet-singh
GITROOT=git@bitbucket.org:${BITBUCKET_ACCOUNT_NAME}
now=$(date +"%m_%d_%Y")


if [ -z "$1" ]; then
    echo "Usage is git-export.sh {repo_name} [{branch_name = master}] [{dir_name = repo_name}]"
    exit 1
fi
 
 
REPO_NAME=$1
BRANCH_NAME=$2
THIS_DIR=$3
 
if [ -z "$BRANCH_NAME" ]; then
    BRANCH_NAME=master
fi
if [ -z "$THIS_DIR" ]; then
    THIS_DIR=$REPO_NAME
fi
 
if [ -d "$THIS_DIR" ]; then
    echo "Error: directory '$THIS_DIR' already exists."
    exit 1$(date +%Y%m%d)
fi
 
echo "Exporting $BRANCH_NAME branch of $REPO_NAME into ./$THIS_DIR..."
mkdir $THIS_DIR
git archive --format=tar --remote=$GITROOT/$REPO_NAME $BRANCH_NAME | gzip > $REPO_NAME-$(date +%Y%m%d).tar.gz 
 
echo "Done"
echo ""
#!/bin/bash

#install required package
if [ $(dpkg-query -W -f='jq' nano 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  apt-get -qq -y install jq parallel;
fi

read -p "Enter your Git UserName: " bbuser
read -s -p "Enter your Git password: " bbpass

REPO_NAME=mirror-sync.git
ORIGIN_URL=git@bitbucket.org:fapsb/$REPO_NAME
REPO1_URL=git@bitbucket.org:fapsb/mirrored-repo.git


bitbucket_get_urls () { 
  curl --user $bbuser:$bbpass https://bitbucket.org/api/1.0/user/repositories | jq '.[].resource_uri' | sed 's/\/1\.0\/repositories\///g' | sed 's/\"//g'   | sed 's/^[^:]*\///g' > reponame
}

bitbucket_set_mirrors(){

  IFS=$'\n' read -d '' -r -a names < reponame

  for x in ${names[@]} ; do


}


rm -rf $REPO_NAME
git clone --bare $ORIGIN_URL
if [ "$?" != "0" ]; then
  echo "ERROR: failed clone of $ORIGIN_URL"
  exit 1
fi
cd $REPO_NAME
git remote add --mirror=fetch repo1 $REPO1_URL
if [ "$?" != "0" ]; then
  echo "ERROR: failed add remote of $REPO1_URL"
  exit 1
fi
git fetch origin --tags
if [ "$?" != "0" ]; then
  echo "ERROR: failed fetch from $ORIGIN_URL"
  exit 1
fi
git fetch repo1 --tags
if [ "$?" != "0" ]; then
  echo "ERROR: failed fetch from $REPO1_URL"
  exit 1
fi
git push origin --all
if [ "$?" != "0" ]; then
  echo "ERROR: failed push to $ORIGIN_URL"
  exit 1
fi
git push origin --tags
if [ "$?" != "0" ]; then
  echo "ERROR: failed push tags to $ORIGIN_URL"
  exit 1
fi
git push repo1 --all
if [ "$?" != "0" ]; then
  echo "ERROR: failed push to $REPO1_URL"
  exit 1
fi
git push repo1 --tags
if [ "$?" != "0" ]; then
  echo "ERROR: failed push tags to $REPO1_URL"
  exit 1
fi
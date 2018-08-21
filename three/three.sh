#!/bin/bash



#install 'jq' package
: '
if [ $(dpkg-query -W -f='jq' nano 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  apt-get -qq -y install jq parallel;
fi
'

: '
if [ $(dpkg-query -W -f='parallel' nano 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  apt-get -qq install parallel;
fi
'

# Enter Username and Password

# read -p "Enter your Git UserName: " bbuser
# read -s -p "Enter your Git password: " bbpass

BITBUCKET_ACCOUNT_NAME=forgeahead
GITROOT=git@bitbucket.org:${BITBUCKET_ACCOUNT_NAME}
now=$(date +"%m_%d_%Y")



user=$USER

BRANCH_NAME=$1

 
if [ -z "$BRANCH_NAME" ]; then
    BRANCH_NAME=master
fi

 
if [ -d "$THIS_DIR" ]; then
    echo "Error: directory '$THIS_DIR' already exists."
    exit 1$(date +%Y%m%d)
fi
 


bitbucket_get_urls () {
	#rm reponame
	#curl --user fa-parmeet-singh:Dj@ngo89 https://bitbucket.org/api/1.0/user/repositories | jq '.[].resource_uri' | sed 's/\/1\.0\/repositories\///g' > reponame
	curl --user fa-parmeet-singh:Dj@ngo89 https://bitbucket.org/api/1.0/user/repositories | jq '.[].resource_uri' | sed 's/\/1\.0\/repositories\///g' | sed 's/\"//g'  	| sed 's/^[^:]*\///g' > reponame

	
}

bb_archive() {

	IFS=$'\n' read -d '' -r -a names < reponame

	for x in ${names[@]} ; do

		#sudo -u $USER mkdir $x
		#git clone git@bitbucket.org:forgeahead/nti-mobile.git
		#echo "hello world" > $x/one.txt
		echo $GITROOT/$x.git
		
		sudo -u $USER git archive --format=tar --remote=$GITROOT/$x.git $BRANCH_NAME | gzip > $x-$(date +%Y%m%d).tar.gz | parallel 
 
	done  

}


bb_backup () {

IFS=$'\n' read -d '' -r -a names < reponame

for x in ${names[@]} ; do

	if [ -d ~/$x ]; then
		cd ~/$x
			 git pull | parallel
		cd ~
	else
		repo=$(echo "https://parmeet89@bitbucket.org/parmeet89/$x.git")
		echo $x
		git clone $repo | parallel 
	fi
	
	#echo $x
	
done  

}

#bitbucket_get_urls
bb_archive
#bb_backup
exit 0

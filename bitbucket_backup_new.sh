#!/bin/bash



#install 'jq' package
if [ $(dpkg-query -W -f='jq' nano 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  apt-get -qq -y install jq parallel;
fi

: '
if [ $(dpkg-query -W -f='parallel' nano 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  apt-get -qq install parallel;
fi
'

# Enter Username and Password

#read -p "Enter your Git UserName: " bbuser
#read -s -p "Enter your Git password: " bbpass

bitbucket_get_urls () {
	#rm reponame
	#curl --user fa-parmeet-singh:Dj@ngo89 https://bitbucket.org/api/1.0/user/repositories | jq '.[].resource_uri' | sed 's/\/1\.0\/repositories\///g' > reponame
	curl --user parmeet89:qweryt567 https://bitbucket.org/api/1.0/user/repositories | jq '.[].resource_uri' | sed 's/\/1\.0\/repositories\///g' | sed 's/\"//g'  	| sed 's/^[^:]*\///g' > reponame

	
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

bitbucket_get_urls
bb_backup
exit 0

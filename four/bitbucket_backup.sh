#!/bin/bash

# Enter Username and Password

read -p "Enter your Git UserName: " bbuser
read -s -p "Enter your Git password: " bbpass

#bbuser='fa-parmeet-singh'
#bbpass=''
bitbucket_get_urls () {
	rm -f bitbucketurls
	echo "curl --user $bbuser:$bbpass https://bitbucket.org/api/1.0/user/repositories > bitbucket.1"
	curl --user $bbuser:$bbpass https://bitbucket.org/api/1.0/user/repositories > bitbucket.1
	tr , '\n' < bitbucket.1 > bitbucket.2
	tr -d '"{}[]' < bitbucket.2 > bitbucket.3
	cat bitbucket.3 |grep -i uri |cut -d":" -f2 >bitbucket.4
	sed 's/\/1\.0\/repositories\///g' bitbucket.4 > bitbucket.5
	cat bitbucket.5 |grep forgeahead > bitbucket.6
	awk  -F/ '{print $2}' bitbucket.6 >> reponame
	rm -f bitbucket.*
}


bb_backup () {
for x in `cat reponame` ; do
	if [ -d ~/$x ]; then
		cd ~/$x
		git pull
		cd ~
	else
		repo=$(echo "git@bitbucket.org:forgeahead/$x.git")
		git clone $repo
	fi
done

}

bitbucket_get_urls
bb_backup
exit 0

: '
for x in `cat reponame` ; do

	if [ -d ~/$x ]; then
		cd ~/$x
		parallel --eta git pull
		cd ~
	else
		repo=$(echo "git@bitbucket.org:forgeahead/$x.git")
		parallel --eta git clone $repo
	fi
	
	echo x
	
done 
readarray a < reponame

for x in $a ; do 
	echo $a
	
	done '
	
	
IFS=$'\n' read -d '' -r -a lines < reponame
#echo "${lines[@]}"

for i in "${lines[@]}" 
do 

	echo "$i"
	
done

	

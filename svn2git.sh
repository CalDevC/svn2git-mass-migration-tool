#!/bin/bash


#Load args
svnUsername=$1
gitUsername=$2
gitPassword=$3
svnName=$4

source settings.sh
svnNameLower=$(echo $svnName | tr [:upper:] [:lower:])
svnRepo="$url/$folderName/$svnName/"

#Create/clean the folder
mkdir tempSVN
cd ./tempSVN/
rm -rf *
rm -rf .*

#Empty ls.txt
> ../ls.txt

#Clone the SVN repo and search write the contents of its root folder to ls.txt
printf "\nCHECKING OUT SVN PROJECT $svnName...\n"
svn checkout $svnRepo >/dev/null
printf "\nCHECKOUT COMPLETE FOR $svnName\n"
cd $svnName
ls -a >> ../../ls.txt

#Create/clean the folder
cd ../../
mkdir tempGit
cd ./tempGit
rm -rf *
rm -rf .*
git init
git config credential.helper store
git config --global user.name "$gitUsername"
git config --global user.password "$gitPassword"

#Get the SVN repo and convert it to git
printf "\nCONVERTING SVN PROJECT $svnName TO GIT...\n"
if grep -Fxq "trunk" ../ls.txt
then
    printf "FOUND TRUNK\n"

	if grep -Fxq "tags" ../ls.txt
	then
		printf "FOUND TAGS\n"

		if grep -Fxq "branches" ../ls.txt
		then
			printf "FOUND BRANCHES\n"
			yes $svnPassword | svn2git $svnRepo --no-minimize-url --username $svnUsername
		else
			printf "NO BRANCHES FOUND\n"
			yes $svnPassword | svn2git $svnRepo --no-minimize-url --username $svnUsername --trunk dev --tags rel --nobranches
		fi

	else
		printf "NO TAGS FOUND\n"
		yes $svnPassword | svn2git $svnRepo --no-minimize-url --username $svnUsername --trunk trunk --nobranches --notags
	fi

else
    printf "NO TRUNK FOUND\n"
	yes $svnPassword | svn2git $svnRepo --no-minimize-url --username $svnUsername --rootistrunk
fi

printf "\nCONVERSION COMPLETE FOR $svnName\n"

#Create the git repo
printf "\nCREATING GIT REMOTE REPO FOR $svnName...\n"

curl --silent --header "PRIVATE-TOKEN: $apiKey" -XPOST "$gitUrl/api/v4/projects?name=$svnName&visibility=internal&initialize_with_readme=false&namespace_id=$groupID"

printf "\nCOMPLETED GIT REPO CREATION FOR $svnName\n"

gitRepo="$gitUrl/$groupURL/$svnNameLower.git"

#Push the new git repo
printf "\nPUSHING $svnName TO GIT LAB REMOTE REPO...\n"
git remote add origin $gitRepo
git push --all origin
git push --tags origin
printf "\n$svnName PUSHED TO GIT LAB\n" >> ../status.txt

#Clean up
rm -r *
rm -rf .git
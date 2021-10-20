#!/bin/bash

source settings.sh

#Get Credentials
printf "Enter your SVN username: "
read svnUsername

printf "Enter your SVN password: "
read svnPassword

printf "Enter your Git Lab username: "
read gitUsername

printf "Enter your Git Lab password: "
read gitPassword

#Build user Git Lab url
echo $gitUrl | tr "//"
urlPieces=$(echo $gitUrl | tr "//" "\n")
userGitUrl=""

for piece in $urlPieces
do
    if [ "$piece" = "http:" ] || [ "$piece" = "https:" ]; then
        userGitUrl=$userGitUrl$piece//$gitUsername@
    else
        userGitUrl=$userGitUrl$piece
    fi
done

echo $userGitUrl

#Run svn2git.exp for every project in the repoNames.txt file
while read -r line; do
    ./svn2git.exp $svnUrl $gitUrl $svnUsername $svnPassword $gitUsername $gitPassword $userGitUrl $line
done  <<<"$(sed 's/\r$//' < repoNames.txt)" #Remove carriage returns
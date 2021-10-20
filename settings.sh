#!/bin/bash

#SVN info
#The base url of your SVN repository (don't end with a / )
svnUrl="https://svnrepo.company.net"

#Starting at your SVN base url, the path to the folder containing all of the repos in repoNames.txt(do not start or end with a / )
folderName="svn/mygroup"

#Git Lab info
gitUrl="https://gitrepo.company.net" #The base url of your Git Lab instance (don't end with a / )
apiKey="Your Private Key Here" #Your Git Lab api key
groupID=1  #The group ID of the group you want to add repos to
groupURL="mygroup"  #The url extension of the group you want to add repos to
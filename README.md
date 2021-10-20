# UPI svn2git

# Usage Instructions
`./launcher.sh`

# The manual migration process

#### INSTRUCTIONS ON HOW TO MOVE UPI SVN REPOSITORIES OVER TO GIT LAB WITHOUT USING THE SCRIPT:
**Created 10/13/21 by WUPQTA**

**This guide is made for windows systems that have WSL installed.\
If you do not have WSL you will need to install it first.\
All commands are meant to be run in the WSL terminal.\
For additional help with problems please reference the "Cut over migration with svn2git" section of the following article:**\
https://docs.gitlab.com/ee/user/project/import/svn.html#cut-over-migration-with-svn2git


1. Create a repo in Git Lab
	- Navigate to http://upigit

	- Go to the group you want the repo to exist in and select:\
	  	New Project > Create blank project

	- Enter the project name, select the group name  from the dropdown under Project URL, 
	  make its visibility level internal, and do not initialize with a readme.

2. Install necessary conversion software (svn2git)
	- Run the following commands to install svn2git:
	  	```
		sudo apt-get install git-core git-svn ruby
	 	sudo gem install svn2git
		```

3. Down-grade your system's SSL:
	- Changing this will lower the security of your system. You should change these settings 
	  back as soon as you have transferred the necessary repo.

	- Run the following to find the location of your SSL conf file:\
		`openssl version -d`

	- Navigate to the printed directory

	- Before making edits to the file it's a good idea to back it 
	  up first. Make a copy to your desktop using: \
	    `sudo cp ./openssl.cnf ~/Desktop`

	- Make the changes to the original file (not the desktop copy)

	- Add the following to the top of the file:\
		`openssl_conf = default_conf`

	- Add the following to the bottom of the file:

		```
		[ default_conf ]

		ssl_conf = ssl_sect

		[ssl_sect]

		system_default = ssl_default_sect

		[ssl_default_sect]
		MinProtocol = TLSv1
		CipherString = DEFAULT:@SECLEVEL=1
		```

	- Save your changes

4. Create a local git repo from the SVN repo
	- Navigate to an EMPTY folder on your local system where you can store
	  the temporary local repo

	- The next command will need to be customized. You will fill in some specific 
	  information and will need to call the command with options appropriate for 
	  the condition of the SVN repo you are cloning. To determine the additional 
	  options that you will need visit the usage section of the README of this git repo:\
	   	https://github.com/nirvdrum/svn2git#usage


	- Fill in the `<SVN url>` and `<username>` pieces of this template command.
	  The SVN url should start with https://projauto.upi.net:8443/svn/ and link to 
	  the SVN repo that you want to clone. The username is your wup account. After 
	  filling out the template, run the command and provide your SVN repo password.

	  **NOTE:** The options included in the following command are necessary along with
	            the other options you deemed necessary in the previous step. Failure to 
		   use the correct options will result in problems connecting your repos. Even 
		   though our SVN repo is password protected, **do not** use the --password option.

	    `svn2git <SVN url> --no-minimize-url --username <username>`
	
5. Connect and push your local git repo to the remote repo
	- Get the clone link to the git repo you created earlier. To do this go to the repo, 
	  click Clone, and copy the Clone with HTTP link.

	- Fill in the `<git url>` piece of this template command with the clone link. Run the 
	  command and provide your upigit credentials if necessary.\
		`git remote add origin <git url>`

	- Run the following 2 commands and provide your upigit credentials if necessary.\
		```
		git push --all origin
		git push --tags origin
		```

6. Clean up
	- Your repo should now be pushed to the remote git repo located at 
	  `http://upigit/<your repo path>` so you can delete the file holding your local version 
	  of this repo.

	- You will need to revert your SSL configuration changes so that you don't leave your 
	  system open vulnerable. To do this, navigate back to your openssl.cnf file and insert 
	  a # at the beginning of every line you added to the file to comment them out. This 
	  will keep them from being used but preserve lines for future use. Reference step 3 
	  of this guide if you can't remember the file's location or what lines you added.

	- Save your changes


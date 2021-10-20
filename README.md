# UPI svn2git

# Usage Instructions
**If you have any issues please visit the Troubleshooting section of this README**

Before running this script for the first time, some initial setup is required.

1. Install needed software and clean scripts
   - To avoid some annoying issues created by Windows line endings we will use dos2unix to first clean up the scripts. This step may not be necessary for everyone, but it's just a precaution.
   - Install it with `sudo apt install dos2unix` or using your equivalent package manager install command
   - You can now clean the cleaner script by running `dos2unix ./cleaner.sh` from the project directory
   - run `./cleaner.sh` to clean the remaining files.
   - Next, install the necessary conversion software (svn2git) by running the following commands or your system's equivalent:
	  	```
		sudo apt-get install git-core git-svn ruby
	 	sudo gem install svn2git
		```

2. Initialize your settings
   - Next you will need to initialize your settings.
   - Navigate to the settings.sh file and fill out each variable with your information.

3. Specify the SVN projects to clone
   - Open the repoNames.txt file and list the names of each of the SVN projects you want to migrate.
   - If you have a very large number of projects and no pre-made list of project names you can easily have SVN generate a list for you. Simply replace `<url>` in the following command with the url to the repository folder holding all of the projects you plan to migrate and run it \
     `svn list <url>`
   - You can copy the printed list and remove any extra `/`'s from the end of the project names using a search and replace tool. 

4. Run the script
   - With the initial setup out of the way, you can now run the program using `./launcher.sh` and watch your Git Lab group fill up with all of your projects.

# Troubleshooting

I came across several issues while developing this tool and I will share that knowledge with you here in hopes that it will help some of you in the future. For additional help with problems please reference the "Cut over migration with svn2git" section of the following article:\
https://docs.gitlab.com/ee/user/project/import/svn.html#cut-over-migration-with-svn2git

#### svn2git has problems connecting to your remote SVN server
For me, this was an issue with the server that the SVN repository was hosted on. It was very old and was using an outdated version of SSL. I had no access to it to upgrade its SSL so I had to downgrade my system's SSL temporarily. I've listed the steps below.
   - Changing this will lower the security of your system. You should change these settings back as soon as you have transferred the necessary repositories.

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

   - You will need to revert your SSL configuration changes so that you don't leave your system vulnerable. To do this, navigate back to your openssl.cnf file and insert a # at the beginning of every line you added to the file to comment them out. This will keep them from being used but preserve lines for future use. Reference step 3 
     of this guide if you can't remember the file's location or what lines you added.




===What's on the box?===

Overview
--------
What's on the box (onbox for short) is a rails webapp for browsing videos stored on a file server.  The idea is that if you have a whole heap of movies on a file server you can easily show your collections to friends or use onbox to select the next movie you want to watch.

Features
--------
 * Auto discovery of new movie or tv show files
 * Automatic translation of movie/tv show file names into correct names
   * E.g. Primer.2004.DVDRip.x264.AC3.avi become Primer (2004)
 * Movie info and posters sourced from IMDB
 * Search by name
 * Browse by genre
 * Mark movies and tv shows as watched
 * Detailed description of a video's file format
 * In-built IMDB search for when auto translation fails
 * Support for bulk editing video IMDB references.

Screenshots
-----------
![Home](http://farm2.static.flickr.com/1334/4606207320_9fe2dee45f.jpg) 
Home Page

![View Video](http://farm4.static.flickr.com/3372/4605593249_ed5216fa88.jpg)
View Video

Installation
------------
Installation is not the easiest, hopefully this will become better overtime.  (This guide has been developed against Ubuntu 10.04)

_Step 1: Install dependencies_

    sudo apt-get install ruby irb rake libopenssl-ruby rubygems1.8 ruby1.8-dev git-core mysql-server libmysql-ruby libmysqlclient-dev
    
Note: It should work with other databases but you will need to modify the adapter in the database.yml file    

_Step 2: Download app_

    sudo mkdir /var/www
    git clone git://github.com/o-sam-o/onbox.git

_Step 3: Install required gems_
    
    sudo gem install -v=2.3.5 rails
    sudo gem install rake chronic packet mysql
    rake gems:install

_Step 4: Setup database_

     mysqladmin -u root -p create onbox
     
     mysql -u root -p
     grant usage on *.* to onbox@localhost identified by 'password_here';
     grant all privileges on onbox.* to onbox@localhost;
     exit

Now update the password in /var/www/onbox/config/database.yml to your password

_Step 5: Migrate database_

    rake db:migrate RAILS_ENV=production

_Step 6: Create first user_

    /var/www/onbox/script/console production
    user = User.create!(:login => 'admin', :password => 'password_here', :password_confirmation => 'password_here')
    exit

_Step 7: Setup a directory for movie posters_

e.g.

    sudo mkdir /var/movie_posters
    sudo chmod 777 /var/movie_posters

Then update /var/www/onbox/config/onbox_config.xml 
and set the production poster_storage to:
/var/movie_posters

_Step 7: Start the app and background processor_

Web Server:
The correct way to to install Passenger. Instructions: [http://www.modrails.com/install.html](http://www.modrails.com/install.html)

The easy way is to use mongrel
    
    sudo gem install mongrel
    cd var/www/onbox/
    sudo ./script/server -d -e production
    
BackgroundRb:
Onbox has a background process that scans for new media and scraps IMDB for video info.  
    
    sudo chmod +x prod_startup.sh
    cd var/www/onbox/
    sudo chmod 777 log/
    export PATH=$PATH:/var/lib/gems/1.8/bin
    ./script/backgroundrb -e production &
    
TODO: Add instructions to make backgroundrb a service

_Step 8: Basic app setup_
You should now be able to hit the web app, it will be http://your.server:3000 if you used mongrel or whatever you setup as part of the mongrel process

 1. Click "Admin" at the top right of the page
 2. Click the "Media Folders" link    
 3. Click "Add Media Folder"
 4. Enter the location of your movie files and check scan, then save
 5. Finally under Admin select "Scan All Folders Now"
 
After a while you should see movies/tv shows appear on the home page.

_Step 9: Install MediaInfo CLI (Optional)_
In order to see details of media file formats you need to install MediaInfo CLI : [http://mediainfo.sourceforge.net/en/Download/Ubuntu](http://mediainfo.sourceforge.net/en/Download/Ubuntu)

Contact
-------
Sam Cavenagh (cavenaghweb@hotmail.com)
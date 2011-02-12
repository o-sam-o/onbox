# What's on the box?

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
 * Embedded HTML5 Video & Quicktime playback

Screenshots
-----------
![Home](http://farm2.static.flickr.com/1334/4606207320_9fe2dee45f.jpg) 

Home Page

![View Video](http://farm4.static.flickr.com/3372/4605593249_ed5216fa88.jpg)

View Video

Installation
------------
Installation is not the easiest, hopefully this will become better overtime.  _(This guide has been developed against Ubuntu 10.04)_

__Step 1: Install dependencies__

    sudo apt-get install ruby irb rake libopenssl-ruby rubygems1.8 ruby1.8-dev git-core mysql-server libmysql-ruby libmysqlclient-dev
    
_Note: Onbox should work with other databases but you will need to modify the adapter in the database.yml file_ 

    install rvm: http://rvm.beginrescueend.com/rvm/install/

__Step 2: Download app__

    sudo mkdir /var/www
    cd /var/www
    git clone git://github.com/o-sam-o/onbox.git

__Step 3: Install required gems__
    
    rvm install 1.8.7
    rvm 1.8.7
    rvm gemset create ob
    rvm 1.8.7@ob
    gem update --system
    gem install bundler
    sudo mkdir .bundle
    sudo chmod 777 .bundle
    bundle install --without development test

__Step 4: Setup database__

     mysqladmin -u root -p create onbox
     
     mysql -u root -p
     grant usage on *.* to onbox@localhost identified by 'password_here';
     grant all privileges on onbox.* to onbox@localhost;
     exit

Now update the password in /var/www/onbox/config/database.yml to your password

__Step 5: Migrate database__

    rake db:migrate RAILS_ENV=production

__Step 6: Create first user__

    /var/www/onbox/script/console production
    user = User.create!(:login => 'admin', :password => 'password_here', :password_confirmation => 'password_here')
    exit

__Step 7: Setup a directory for movie posters__

e.g.

    sudo mkdir /var/movie_posters
    sudo chmod 777 /var/movie_posters

Then update /var/www/onbox/config/onbox_config.xml 
and set the production poster_storage to:
/var/movie_posters

__Step 8: Start the app and background processor__

_Web Server:_
The correct way is to install Passenger. Instructions: [http://www.modrails.com/install.html](http://www.modrails.com/install.html)

The easy way is to use mongrel
    
    sudo gem install mongrel
    cd var/www/onbox/
    sudo ./script/server -d -e production
    
_BackgroundRb:_
Onbox has a background process that scans for new media and scraps IMDB for video info.  
    
    cd var/www/onbox/
    sudo chmod 777 log/
    sudo chmod 777 pid/
    ./script/backgroundrb -e production &
    
_TODO: Add instructions to make backgroundrb a service_

__Step 9: Basic app setup__
You should now be able to hit the web app, it will be at http://your.server:3000 if you used mongrel or whatever you setup as part of the passenger install.

 1. Click "Admin" at the top left of the page
 2. Click the "Media Folders" link    
 3. Click "Add Media Folder"
 4. Enter the location of your movie files, check scan and press save
 5. Finally under Admin select "Scan All Folders Now"
 
After a while you should see movies/tv shows appear on the home page.

__Step 10: Install MediaInfo CLI (Optional)__
In order to see details of media file formats you need to install MediaInfo CLI : [http://mediainfo.sourceforge.net/en/Download/Ubuntu](http://mediainfo.sourceforge.net/en/Download/Ubuntu)

Client-side Video Playback
--------------------------
The video playback support is a little spotty. If the video is mp4 onbox will use the html video tag, however, this won't work in firefox.  For other formats (e.g. avi) quicktime is used, if you have [perian](http://perian.org/) installed codecs such as divx should work.  That said, firefox and chrome seem to want to download the whole video before playing it back.  It plays back immediately in safari for me.

Licence
-------
MIT (excluding all the stuff copied from others, e.g. theme)

Contact
-------
Sam Cavenagh [(cavenaghweb@hotmail.com)](mailto:cavenaghweb@hotmail.com)

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

task :default => ["test:units"]

desc "Re-download imdb sample pages used in tests (Do this when imdb updates)"
task :download_fixture_html do
  page_into_file('http://www.imdb.com/title/tt0499549/', 'test/unit/workers/Avatar.2009.html')
  page_into_file('http://www.imdb.com/title/tt0411008/', 'test/unit/workers/Lost.2004.html')
  page_into_file('http://www.imdb.com/title/tt0411008/episodes', 'test/unit/workers/Lost.2004.Episodes.html')
  page_into_file('http://www.imdb.com/find?s=all&q=starkey+and+hutch', 'test/unit/workers/starkey_hutch_search.html')
  page_into_file('http://www.imdb.com/media/rm815832320/tt0093437', 'test/unit/workers/media_page.html')
end

def page_into_file(request_url, file_name)
  require 'net/http'

  file = File.new(file_name, "w")
  file.write(Net::HTTP.get(URI.parse(request_url)))
  file.close

  p "Refreshed #{file_name}"
end

desc "Setup a test folder of fake media files and create test admin user"
task :setup_dev_env => [:environment, 'db:reset'] do
  `create_dev_test.sh`
  MediaFolder.create!(:location => '/tmp/OnBoxDev', :scan => true)
  User.create!(:login => 'admin', :password => 'password', :password_confirmation => 'password')
  p "Created user 'admin' with password 'password'"
end

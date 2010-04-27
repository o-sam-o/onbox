require File.join(File.dirname(__FILE__), "/../../bdrb_test_helper")
require "lib/workers/folder_scan_worker" 

class FolderScanWorkerTest < Test::Unit::TestCase

  should 'check all active media folders' do
    folder1 = MediaFolder.new(:location => 'one')
    folder2 = MediaFolder.new(:location => 'two')
    MediaFolder.expects(:find_all_by_scan).returns([folder1, folder2])
    Util::FolderScanner.expects(:find_content_in_folder).with('one').multiple_yields('f1', 'f2')
    Util::FolderScanner.expects(:find_content_in_folder).with('two').yields('f3')
    
    worker = FolderScanWorker.new
    worker.expects(:process_media_file).with('f1', folder1)
    worker.expects(:process_media_file).with('f2', folder1)
    worker.expects(:process_media_file).with('f3', folder2)
    
    worker.scan_all_folders
  end  

  should 'gracefully handle exceptions when check all active media folders' do
    folder1 = MediaFolder.new(:location => 'one')
    folder2 = MediaFolder.new(:location => 'two')
    MediaFolder.expects(:find_all_by_scan).returns([folder1, folder2])
    Util::FolderScanner.expects(:find_content_in_folder).with('one').multiple_yields('f1', 'f2')
    Util::FolderScanner.expects(:find_content_in_folder).with('two').yields('f3')
    
    worker = FolderScanWorker.new
    worker.expects(:process_media_file).with('f1', folder1).raises
    worker.expects(:process_media_file).with('f2', folder1)
    worker.expects(:process_media_file).with('f3', folder2)
    
    worker.scan_all_folders
  end

  should 'return existing file references if it already exists' do
    file = VideoFileReference.new
    folder = MediaFolder.new(:location => 'folder')
    VideoFileReference.expects(:find_by_location).with('location').returns(file)
    worker = FolderScanWorker.new
    worker_file = worker.send(:get_file_reference, 'location', folder)
    
    assert_equal file, worker_file
  end  

  should 'create a new file references if one doenst already exist' do
    file = VideoFileReference.new
    folder = MediaFolder.new(:location => 'folder')
    VideoFileReference.expects(:find_by_location).with('location').returns(nil)
    VideoFileReference.expects(:new).returns(file)
    file.expects(:save!)
        
    worker = FolderScanWorker.new
    worker.expects(:update_file_properties)
    worker_file = worker.send(:get_file_reference, 'location', folder)
    
    assert_equal file, worker_file
  end
  
  should 'find video content by name and year' do
    movie = Movie.new
    
    VideoContent.expects(:find_by_name).returns(movie)
    worker = FolderScanWorker.new
    worker_movie = worker.send(:find_video_content, 'name', nil)
    assert_equal movie, worker_movie
    
    
    VideoContent.expects(:find_by_name_and_year).returns(movie)
    worker = FolderScanWorker.new
    worker_movie = worker.send(:find_video_content, 'name', 2000)
    assert_equal movie, worker_movie    
  end

  should "create a new movie if one doesn't already exist" do
    file = VideoFileReference.new(:updated_at => DateTime::now())
    folder = MediaFolder.new(:location => 'folder')
    movie = Movie.new
    worker = FolderScanWorker.new
    
    worker.expects(:get_file_reference).returns(file)
    File.expects(:mtime).returns(5.minutes.ago)
    VideoContent.expects(:find_by_name).with('avatar').returns(nil)
    
    
    Movie.expects(:new).returns(movie)
    movie.expects(:save!)
    file.expects(:save!)
    
    mock_worker = mock()
    MiddleMan.expects(:worker).returns(mock_worker)
    mock_worker.expects(:async_scrap_for_video_content)

    worker.send(:process_media_file, '/test/avatar.mpg', folder)

    assert_equal movie, file.video_content
  end
  
  should "create a new tv show if one doesn't already exist" do
    file = VideoFileReference.new(:updated_at => DateTime::now())
    folder = MediaFolder.new(:location => 'folder')
    tv_show = TvShow.new
    worker = FolderScanWorker.new
    
    worker.expects(:get_file_reference).returns(file)
    File.expects(:mtime).returns(5.minutes.ago)
    VideoContent.expects(:find_by_name).with('Lost').returns(nil)
    
    
    TvShow.expects(:new).returns(tv_show)
    tv_show.expects(:save!)
    file.expects(:save!)
    
    mock_worker = mock()
    MiddleMan.expects(:worker).returns(mock_worker)
    mock_worker.expects(:async_scrap_for_video_content)

    worker.send(:process_media_file, '/test/Lost.S03E05.mpg', folder)

    assert_equal tv_show, file.video_content
  end
  
  should 'associate a new references with a matching movie' do
    file = VideoFileReference.new(:updated_at => DateTime::now())
    folder = MediaFolder.new(:location => 'folder')
    movie = Movie.new
    worker = FolderScanWorker.new
    
    worker.expects(:get_file_reference).returns(file)
    File.expects(:mtime).returns(5.minutes.ago)
    VideoContent.expects(:find_by_name).with('avatar').returns(movie)
    
    file.expects(:save!)

    worker.send(:process_media_file, '/test/avatar.mpg', folder)

    assert_equal movie, file.video_content
  end    

  should 'update video file properties if references newer than file' do
    file = VideoFileReference.new(:updated_at => 5.minutes.ago, :location => '/test/avatar.mpg')
    folder = MediaFolder.new(:location => 'folder')
    movie = Movie.new
    file.video_content = movie
    worker = FolderScanWorker.new
    existing_property = VideoFileProperty.new(:name => 'prop-name', :group => 'group', :value => 'a')
    properties_mock = mock()
    file.expects(:video_file_properties).times(3).returns(properties_mock)
    properties_mock.expects(:each).yields(existing_property)
    
    worker.expects(:get_file_reference).returns(file)
    File.expects(:mtime).returns(DateTime::now())
    
    Util::MediaInfoUtil.expects(:get_media_info).with(file.location).returns([Util::MediaInfoValue.new(:key => 'n1', :group => 'g1', :value => 'xxx'),
      Util::MediaInfoValue.new(:key => 'Format', :group => 'General', :value => 'mpg'),
      Util::MediaInfoValue.new(:key => 'prop-name', :group => 'group', :value => 'ppp')])
    
    prop_mock = mock()
    properties_mock.expects(:build).times(2).returns(prop_mock)
    prop_mock.expects(:save!).times(2)
    existing_property.expects(:update_attributes!).with({:name => 'prop-name', :order => 2, :group => 'group', :value => 'ppp'})
    
    file.expects(:update_attribute).with(:format, 'mpg')

    worker.send(:process_media_file, '/test/avatar.mpg', folder)
  end  

end
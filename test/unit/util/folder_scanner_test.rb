require 'test/unit'
require "lib/util/folder_scanner"
require 'fakefs/safe'

class FolderScannerTest < Test::Unit::TestCase
  
  context 'fake fs' do
  
    setup do
      FakeFS::FileSystem.clear
    end  
    
    should 'yield nothing for an empty dir' do
      FakeFS do
        FileUtils.mkdir_p("/content/dir")

        assert get_media_files.empty?
      end
    end
  
    should 'should yeild nothing no media files' do
      FakeFS do
        FileUtils.mkdir_p("/content/dir")
        FileUtils.mkdir_p("/content/dir/sub")
        FileUtils.touch "/content/dir/sub/media.zip"
        FileUtils.touch "/content/dir/sub/media.jpg"
        FileUtils.touch "/content/dir/sub/media.tar"
        FileUtils.touch "/content/dir/sub/media.tar.gz"

        assert get_media_files.empty?
      end  
    end  
  
    should 'should yeild media file' do
      FakeFS do
        FileUtils.mkdir_p("/content/dir")
        FileUtils.touch "/content/dir/media.mpg"

        assert_equal ['/content/dir/media.mpg'], get_media_files
      end  
    end 
    
    should 'should yeild nfo file if no media files' do
      FakeFS do
        FileUtils.mkdir_p("/content/dir")
        FileUtils.mkdir_p("/content/dir/sub")
        FileUtils.touch "/content/dir/sub/media.zip"
        FileUtils.touch "/content/dir/sub/media.jpg"
        FileUtils.touch "/content/dir/sub/media.nfo"

        assert_equal ['/content/dir/sub/media.nfo'], get_media_files
      end  
    end 
    
    should 'should not yeild nfo file if media files' do
      FakeFS do
        FileUtils.mkdir_p("/content/dir")
        FileUtils.mkdir_p("/content/dir/sub")
        FileUtils.touch "/content/dir/sub/media.zip"
        FileUtils.touch "/content/dir/sub/media.jpg"
        FileUtils.touch "/content/dir/sub/media.nfo"
        FileUtils.touch "/content/dir/sub/media.avi"

        assert_equal ['/content/dir/sub/media.avi'], get_media_files
      end  
    end    

    should 'should not yeild nfo file if nested media files' do
      FakeFS do
        FileUtils.mkdir_p("/content/dir")
        FileUtils.mkdir_p("/content/dir/sub/CD1")
        FileUtils.touch "/content/dir/sub/media.zip"
        FileUtils.touch "/content/dir/sub/media.jpg"
        FileUtils.touch "/content/dir/sub/media.nfo"
        FileUtils.touch "/content/dir/sub/CD1/media.avi"

        assert_equal ['/content/dir/sub/CD1/media.avi'], get_media_files
      end  
    end

    should 'should yeild all media file types' do
      FakeFS do
        FileUtils.mkdir_p("/content/dir")
        FileUtils.mkdir_p("/content/dir/sub")
        FileUtils.touch "/content/dir/sub/media.avi"
        FileUtils.touch "/content/dir/sub/media.mpg"
        FileUtils.touch "/content/dir/sub/media.mp4"
        FileUtils.touch "/content/dir/sub/media.mkv"
        FileUtils.touch "/content/dir/sub/media.mov"
        FileUtils.touch "/content/dir/sub/media.m4v"

        assert_equal ['/content/dir/sub/media.avi', '/content/dir/sub/media.mpg', '/content/dir/sub/media.mp4', 
            '/content/dir/sub/media.mkv', '/content/dir/sub/media.mov', '/content/dir/sub/media.m4v'].sort, get_media_files.sort
      end  
    end
  
    should 'should yeild media file even if several folders deep' do
      FakeFS do
        FileUtils.mkdir_p("/content/dir")
        FileUtils.mkdir_p("/content/dir/sub/sub/sub")
        FileUtils.touch "/content/dir/sub/sub/sub/media.mpg"

        assert_equal ['/content/dir/sub/sub/sub/media.mpg'], get_media_files
      end  
    end
  
  end
  
  def get_media_files
    media_files = []
    FolderScanner.find_content_in_folder('/content/dir') do |file|
      media_files << file
    end
    return media_files
  end  
  
end
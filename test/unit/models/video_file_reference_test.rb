require 'test_helper'

class VideoFileReferenceTest < ActiveSupport::TestCase
  should_validate_presence_of :location
  should_validate_uniqueness_of :location
  should_belong_to :media_folder, :video_content
  should_have_many :video_file_properties
  
  should 'return content name' do
    reference = VideoFileReference.new
    assert_equal nil, reference.video_content_name
    reference.video_content = Movie.new(:name => 'test name')
    assert_equal 'test name', reference.video_content_name
  end
  
  should 'sort based on name if movie' do
    one = VideoFileReference.new(:location => '/test/movieA.avi')
    two = VideoFileReference.new(:location => '/test/movieB.avi')
    
    assert (one <=> two) < 0
    assert (two <=> one) > 0
  end
  
  should 'sort based on year if the name is the same for movie' do
    one = VideoFileReference.new(:location => '/test/movieA.2004.avi')
    two = VideoFileReference.new(:location => '/test/movieA.1999.avi')
    
    assert (one <=> two) < 0
    assert (two <=> one) > 0
  end  
  
  should 'sort based on series if a tv show' do
    one = VideoFileReference.new(:location => '/test/movieA.S01E01.avi')
    two = VideoFileReference.new(:location => '/test/movieA.S02E01.avi')
    
    assert (one <=> two) < 0
    assert (two <=> one) > 0
  end  
  
  should 'sort based on episode if a tv show as same series' do
    one = VideoFileReference.new(:location => '/test/movieA.S01E01.avi')
    two = VideoFileReference.new(:location => '/test/movieA.S01E02.avi')
    
    assert (one <=> two) < 0
    assert (two <=> one) > 0
  end  
  
  should 'not fail if nil location when sorting' do
    one = VideoFileReference.new(:raw_name => '/test/movieA.S01E01.avi')
    two = VideoFileReference.new(:location => '/test/movieA.S01E02.avi')
    
    assert (one <=> two) < 0
    assert (two <=> one) > 0
  end  
  
  should 'find unique property groups' do
    ref = VideoFileReference.new 
    ref.video_file_properties << VideoFileProperty.new(:group => 'one')
    ref.video_file_properties << VideoFileProperty.new(:group => 'two')
    ref.video_file_properties << VideoFileProperty.new(:group => 'one')
    
    assert ref.video_file_properties.unique_groups == ['one', 'two']
  end  
end

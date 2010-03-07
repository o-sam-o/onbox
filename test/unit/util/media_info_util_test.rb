require 'lib/util/media_info_util'

class WalkerTest < Test::Unit::TestCase
  def test_get_media_info
    info = MediaInfoUtil.get_media_info(File.join(File.dirname(__FILE__), 'test.mov'))
    info_map = {}
    info.each { |i| info_map[i.group + '-' + i.key] = i.value }
    assert_equal('MPEG-4', info_map['General-Format'])
    assert_equal('1s 91ms', info_map['General-Duration'])
    assert_equal('3 858 Kbps', info_map['General-Overall bit rate'])
    
    assert_equal('AVC', info_map['Video-Format'])
    assert_equal('Advanced Video Coding', info_map['Video-Codec ID/Info'])
    assert_equal('30.000 fps', info_map['Video-Frame rate'])
    assert_equal('640 pixels', info_map['Video-Width'])
    
    assert_equal('AAC', info_map['Audio-Format'])
    assert_equal('Constant', info_map['Audio-Bit rate mode'])
    assert_equal('44.1 KHz', info_map['Audio-Sampling rate'])
  end
  
  def test_nfo_file
    info = MediaInfoUtil.get_media_info(File.join(File.dirname(__FILE__), 'test.nfo'))
    assert_equal({}, info)
  end
end
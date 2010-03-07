class MediaInfoValue
  attr_accessor :group, :key, :value
  
  def initialize(params = {})
    @group = params[:group]
    @key = params[:key]
    @value = params[:value]
  end

end  

class MediaInfoUtil

  def self.get_media_info(file_name)
    # We only want to run media info on media files
    return {} if file_name =~ /nfo$/
    
    out = `mediainfo "#{file_name}" 2>&1`
    if $?.to_i != 0
      RAILS_DEFAULT_LOGGER.error "Mediainfo called failed ... is it installed? Message: #{out}"
      return []
    end
    
    info = []
    key_group = ''
    for line in out.split(/\n/)
      next if line.blank?
      if line =~ /([^\:]*)\:(.*)/
        key, value = $1.strip, $2.strip
        next if key.blank? or value.blank?
        info << MediaInfoValue.new({:group => key_group, :key => key, :value => value})
      else
        key_group = line.strip
      end
    end

    return info
  end 

end
class FileNameInfo
  attr_accessor :raw_name, :location, :name, :year, :series, :episode
  
  def initialize(params = {})
    @name = params[:name]
    @year = params[:year]
    @raw_name = params[:raw_name]
    @location = params[:location]
    @series = params[:series]
    @episode = params[:episode]
  end

  def to_s
    s = ''
    if @name
      s += @name
      s += " [#{@year}]" if @year
      s += " S: #{@series} E: #{@episode}" if @series || @episode
    elsif @raw_name
      s += @raw_name
    else
      s += @location
    end
    s
  end
end

class FileNameCleaner

  FILE_SEP_REGEX = /\//
  FILE_EXT_SEP_REGEX = /\./
  #Chars used in file names as a subsitude for spaces
  SPACE_SUB_REGEX = /(\.|_|\-)/
  CONTENT_SOURCE_REGEX = /(\(|\[|\s)+(DVDRIP|1080p|720p|R5|DVDSCR|BDRip|CAM|TS|PPV|Xvid|divx)(\)|\]|\s|$)+/i
  YEAR_REGEX = /(\(|\[|\s)+\d{4}(,|\)|\]|\s|$)+/
  SESSION_ESP_REGEX_1 = /S(\d{2})\s?E(\d{2})/i
  SESSION_ESP_REGEX_2 = /\s+(\d+)x(\d+)(\s|$)+/i
  SESSION_ESP_REGEX_OF = /(\d+)\s?of\s?(\d+)/i

  def self.get_file_name(location)
    file_name = location.dup
    #Change to just the filename
    file_name = file_name[file_name.rindex(FILE_SEP_REGEX) + 1, file_name.length] if file_name =~ FILE_SEP_REGEX  
  end

  def self.get_name_info(location)
    raw_name = self.get_file_name(location)
    #Remove file extention
    raw_name = raw_name[0, raw_name.rindex(FILE_EXT_SEP_REGEX)] if raw_name =~ FILE_EXT_SEP_REGEX
    #Remove space sub chars  
    raw_name = raw_name.gsub(SPACE_SUB_REGEX, ' ')

    name = raw_name.dup
    #Chop off any info about the movie format or source
    name = $` if name =~ CONTENT_SOURCE_REGEX

    #Extract year if it's in the filename
    if name =~ YEAR_REGEX && name.index(YEAR_REGEX) > 0
      name = $`
      #Strip any surronding brackets and convert to int
      year = $&.gsub(/\(|\)|\[|\]/, '').to_i
    end

    #Try to extract the session and episode
    if name =~ SESSION_ESP_REGEX_1
      name = $`
      session = $1.to_i
      episode = $2.to_i
    elsif name =~ SESSION_ESP_REGEX_2
        name = $`
        session = $1.to_i
        episode = $2.to_i    
    elsif name =~ SESSION_ESP_REGEX_OF
      name = $`
      session = 1
      episode = $1.to_i  
    end
    name.strip!

    return FileNameInfo.new(:raw_name => raw_name, :name => name, :year => year, 
                            :series => session, :episode => episode, :location => location)  
  end

end
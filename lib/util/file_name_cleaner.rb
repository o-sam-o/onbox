module Util
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
    
    def <=>(other)
      if series && other.series && series != other.series
        return (series <=> other.series) 
      elsif episode && other.episode && episode != other.episode
        return (episode <=> other.episode)
      elsif name != other.name
        return (name <=> other.name)
      elsif year && other.year
        #Note: with year we want newest first
        return (other.year <=> year)
      else
        return 0
      end
    end
  end

  class FileNameCleaner

    FILE_SEP_REGEX = /\//
    FILE_EXT_SEP_REGEX = /\./
    CD_FOLDER_REGEX = /\/CD(\d)\//
    #Chars used in file names as a subsitude for spaces
    SPACE_SUB_REGEX = /(\.|_|\-)/
    #TODO remove this duplication
    CONTENT_SOURCES = /DVDRIP|1080p|720p|R5|DVDSCR|BDRip|CAM|TS|PPV|Xvid|divx/i
    CONTENT_SOURCE_REGEX = /(\(|\[|\s)+(DVDRIP|1080p|720p|R5|DVDSCR|BDRip|CAM|TS|PPV|Xvid|divx)(\)|\]|\s|$)+/i
    YEAR_REGEX = /(\(|\[|\s)+\d{4}(,|\)|\]|\s|$)+/
    SESSION_ESP_REGEX_1 = /S(\d{2})\s?E(\d{2})/i
    SESSION_ESP_REGEX_2 = /\s+(\d+)x(\d+)(\s|$)+/i
    SESSION_ESP_REGEX_3 = /Season (\d+) Episode (\d+)/i
    SESSION_ESP_REGEX_OF = /(\d+)\s?of\s?(\d+)/i
    SESSION_REGEXS = [SESSION_ESP_REGEX_1, SESSION_ESP_REGEX_2, SESSION_ESP_REGEX_3]
  

    def self.get_file_name(location)
      file_name = location.dup
      #Change to just the filename
      file_name = file_name[file_name.rindex(FILE_SEP_REGEX) + 1, file_name.length] if file_name =~ FILE_SEP_REGEX  
    
      return file_name
    end

    def self.parent_folder_name(location)
      # Remove first / and break by folder name
      folders = location.sub(/^\//, '').split('/')
      return nil if folders.empty? || folders.size < 2
      parent_folder = folders[folders.size - 2]
      # If the folder is a CD folder e.g. CD1 go up 1 more
      return folders[folders.size - 3] if folders.size > 2 && parent_folder  =~ /CD\d/i
      return parent_folder
    end  

    def self.get_name_info(location)
      raw_name = self.get_file_name(location)
    
      #Check to see if we are better off looking at the folder name
      check_extention = true
      unless raw_name =~ CONTENT_SOURCE_REGEX || raw_name =~ SESSION_ESP_REGEX_1
        parent_folder = self.parent_folder_name(location)
        if parent_folder && parent_folder =~ CONTENT_SOURCES
          raw_name = parent_folder
          check_extention = false
        end  
      end  
    
      #Remove file extention
      raw_name = raw_name[0, raw_name.rindex(FILE_EXT_SEP_REGEX)] if check_extention && raw_name =~ FILE_EXT_SEP_REGEX
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

      #Strip LIMITED off the end.  Note: This is NOT case sensitive
      name = $` if name =~ /LIMITED$/

      #Try to extract the session and episode
      session = nil
      episode = nil
      SESSION_REGEXS.each do |session_regex|
        if name =~ session_regex
          name = $`
          session = $1.to_i
          episode = $2.to_i
          break
        end
      end  
  
      if session.nil? && name =~ SESSION_ESP_REGEX_OF
        name = $`
        session = 1
        episode = $1.to_i  
      end

      # Sometimes there can be multiple media files for a single movie, we want to remove the version number if this is the case
      if location =~ CD_FOLDER_REGEX
        cd_number = $1.to_i
        if name =~ /#{cd_number}$/
          name = $`
        elsif name =~ /part\s?#{cd_number}/i
          name = $`
        end  
      end  

      name.strip!
      return FileNameInfo.new(:raw_name => raw_name, :name => name, :year => year, 
                              :series => session, :episode => episode, :location => location)  
    end

  end
end
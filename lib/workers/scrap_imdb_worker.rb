class ScrapImdbWorker < BackgrounDRb::MetaWorker
  set_worker_name :scrap_imdb_worker

  def scrap_all_pending
    logger.debug "About to scrap imdb content for all pending video contents"
    for video_content in VideoContent.find_all_by_state('pending')
      begin
        scrap_imdb(video_content)
      rescue Exception => exception 
        logger.error("Error scraping video content #{video_content.id}:\n #{exception.class} (#{exception.message}):\n    " +
           exception.backtrace.join("\n    ") + "\n\n")
      end  
    end
    logger.debug "Done scraping content for all pending video contents"
  end
  
  def scrap_for_video_content(id)
    logger.debug "About to scrap imdb for video content id: #{id}"
    video_content = VideoContent.find(id)
    begin
      scrap_imdb(video_content)
      logger.debug "Done scraping content for #{id}"
    rescue Exception => exception 
      logger.error("Error scraping video content #{id}:\n #{exception.class} (#{exception.message}):\n    " +
         exception.backtrace.join("\n    ") + "\n\n")
    end  
  end
  
  private
    def get_imdb_id(video_content)
      imdb_id = video_content.imdb_id
      if imdb_id.blank?
        imdb_id = YayImdbs.search_for_imdb_id(video_content.name, video_content.year, video_content.tv_show? ? :tv_show : :movie)
      end
      return imdb_id
    end
    
    def scrap_imdb(video_content)
      logger.info "Scraping imdb for video content: #{video_content.id}"
      imdb_id = get_imdb_id(video_content)
      if imdb_id.blank?
        logger.error("Failed to find imdb id for video: #{video_content.display_name}")
        video_content.state = 'no_imdb_id'
        video_content.save! and return
      elsif !video_content.unique_imdb_id?(imdb_id)
        logger.info "Found duplicate video content for imdb id #{imdb_id} merging"
        video_content.merge_with_imdb_id(imdb_id)
        return
      end  
      
      logger.debug "Found imdb_id #{imdb_id} for #{video_content.display_name}"
      movie_info = YayImdbs.scrap_movie_info(imdb_id)
      genres = movie_info['genre'] ? movie_info['genre'].collect { |name| Genre.find_or_create_by_name(name) } : []
      if video_content.type != movie_info['video_type']
        logger.debug "Changing video type to #{movie_info['video_type']}"
        video_content.change_type(movie_info['video_type'] == :movie ? 'Movie' : 'TvShow')
      end
      
      case movie_info['video_type']
      when :movie
        video_content.update_attributes!(:name => movie_info['title'], :year => movie_info['year'],
                                         :imdb_id => imdb_id, :plot => movie_info['plot'], 
                                         :release_date => movie_info['release_date'], :genre_ids => genres.collect { |g| g.id },
                                         :director => movie_info['director'], :tag_line => movie_info['tagline'],
                                         :language => movie_info['language'].first, :runtime => movie_info['runtime'],
                                         :rating => movie_info['rating'], :state => 'processed')
      when :tv_show
        video_content.update_attributes!(:name => movie_info['title'], :year => movie_info['year'],
                                         :imdb_id => imdb_id, :plot => movie_info['plot'], 
                                         :genre_ids => genres.collect { |g| g.id }, :tag_line => movie_info['tagline'],
                                         :language => movie_info['language'].first, :runtime => movie_info['runtime'],
                                         :rating => movie_info['rating'], :state => 'processed')
        # Reload if conten type changed so we can set the episodes
        video_content = VideoContent.find(video_content.id) unless video_content.tv_show?
        video_content.tv_episodes.replace(create_or_load_tv_episodes(movie_info, video_content)) 
      else
        raise "Unknown video content #{movie_info['video_type']} (#{video_content.id})"
      end
      logger.debug "About to download posters"
      get_movie_posters(movie_info, video_content)
    end
    
    def create_or_load_tv_episodes(movie_info, video_content)
      tv_episodes = []
      files = get_files_by_series_and_episode(video_content)
        
      movie_info['episodes'].each do |episode_info|
        tv_episode = video_content.tv_episodes.find(:first, 
          :conditions => {:series => episode_info['series'], :episode => episode_info['episode']}) 
        file_reference = files[episode_info['series']][episode_info['episode']] rescue nil
        if tv_episode
          tv_episode.update_attributes!(:title => episode_info['title'], 
                                        :plot => episode_info['plot'], 
                                        :date => episode_info['date'],
                                        :video_file_reference => file_reference)
        else
          tv_episode = video_content.tv_episodes.create!(:series => episode_info['series'], :episode => episode_info['episode'],
                                                         :title => episode_info['title'], :plot => episode_info['plot'], 
                                                         :date => episode_info['date'], :video_file_reference => file_reference)
        end
        tv_episodes << tv_episode
      end if movie_info['episodes']
      return tv_episodes
    end
    
    def get_files_by_series_and_episode(video_content)
      files = {}
      
      video_content.video_file_references.each do |file|
        file_info = ToName.to_name(file.location)
        series = (file_info.series ? file_info.series : 1)
        files[series] = [] unless files[series]
        files[series][file_info.episode] = file if file_info.episode
      end if video_content.video_file_references
      
      return files
    end  
    
    def get_movie_posters(movie_info, video_content)
      get_movie_poster(movie_info['small_image'], 'small', video_content) if movie_info['small_image']
      get_movie_poster(movie_info['large_image'], 'large', video_content) if movie_info['large_image']
    end
    
    def get_movie_poster(url, size, video_content)
      if video_content.poster(size)
        logger.debug "Not downloading poster for #{video_content.display_name} as one of size #{size} already exist"
        return
      end
      img_name = poster_file_name(video_content.name, video_content.year, size, File.extname(url))
      img_complete_path = File.join(storage_dir, img_name)
      rio(img_complete_path) < rio(url)
      logger.debug "Downloaded poster #{url} to #{img_complete_path}"
      width, height = ImageSize.new(File.new(img_complete_path, "r")).get_size
      poster = VideoPoster.new(:location => img_name, :size => size, :video_content_id => video_content.id,
                                :width => width, :height => height)
      poster.save!
    end
    
    # Generates a filename based on name, year and size.  Ensures name is unique by adding numbers on the end
    def poster_file_name(name, year, size, ext, attempt = 1)
      #Clean movie name, it may contain invalid chars
      file_name = name.gsub(/\s/, '.').gsub(/[^a-zA-Z_0-9\.]/, '').downcase
      file_name += ".#{year}" if year      
      file_name += ".#{size}"
      file_name += ".#{attempt}" if attempt > 1
      file_name += ext if ext
      if File.exists?(File.join(storage_dir, file_name))
        file_name = poster_file_name(name, year, size, ext, attempt + 1)
      end
      return file_name
    end
    
    def storage_dir
      return ONBOX_CONFIG[:poster_storage]
    end
end


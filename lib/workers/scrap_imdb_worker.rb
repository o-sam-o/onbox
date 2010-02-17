require 'rubygems'
require 'rio'
require 'image_size'
require 'lib/util/imdb_metadata_scraper'

class ScrapImdbWorker < BackgrounDRb::MetaWorker
  set_worker_name :scrap_imdb_worker

  def scrap_all_pending
    logger.debug "About to scrap imdb content for all pending video contents"
    for video_content in VideoContent.find_all_by_state('pending')
      scrap_imdb(video_content)
    end
    logger.debug "Done scraping content for all pending video contents"
  end
  
  def scrap_for_video_content(id)
    logger.debug "About to scrap imdb for video content id: #{id}"
    video_content = VideoContent.find(id)
    scrap_imdb(video_content)
    logger.debug "Done scraping content for #{id}"
  end
  
  private
    def get_imdb_id(video_content)
      imdb_id = video_content.imdb_id
      if not imdb_id or imdb_id.blank?
        imdb_id = ImdbMetadataScraper.search_for_imdb_id(video_content.name, video_content.year)
      end
      return imdb_id
    end
    
    def scrap_imdb(video_content)
      logger.info "Scraping imdb for video content: #{video_content.id}"
      imdb_id = get_imdb_id(video_content)
      if not imdb_id
        logger.error("Failed to find imdb id for video: #{video_content.display_name}")
        video_content.state = VideoContentState::NO_IMDB_ID
        video_content.save! and return
      end
      
      logger.debug "Found imdb_id #{imdb_id} for #{video_content.display_name}"
      movie_info = ImdbMetadataScraper.scrap_movie_info(imdb_id)
      video_content.update_attributes!({:name => movie_info['title'], :year => movie_info['year'],
                                        :imdb_id => imdb_id, :plot => movie_info['plot'], 
                                        :release_date => movie_info['release date'],
                                        :state => VideoContentState::PROCESSED})
      logger.debug "About to download posters"
      get_movie_posters(movie_info, video_content)
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
      img_complete_path = File.join(VideoPostersController::ROOT_POSTER_DIR, img_name)
      rio(img_complete_path) < rio(url)
      logger.debug "Downloaded poster #{url} to #{img_complete_path}"
      width, height = ImageSize.new(File.new(img_complete_path, "r")).get_size
      poster = VideoPoster.new({:location => img_name, :size => size, :video_content_id => video_content.id,
                                :width => width, :height => height})
      poster.save!
    end
    
    # Generates a filename based on name, year and size.  Ensures name is unique by adding numbers on the end
    def poster_file_name(name, year, size, ext, attempt = 1)
      file_name = name.gsub(/\s/, '.').downcase
      file_name += ".#{year}" if year      
      file_name += ".#{size}"
      file_name += ".#{attempt}" if attempt > 1
      file_name += ext if ext
      if File.exists?(file_name)
        file_name = poster_file_name(name, year, ext, attempt + 1)
      end
      return file_name
    end
end


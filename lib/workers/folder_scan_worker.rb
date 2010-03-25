require "lib/util/folder_scanner"
require "lib/util/file_name_cleaner"
require "lib/util/media_info_util"

class FolderScanWorker < BackgrounDRb::MetaWorker
  set_worker_name :folder_scan_worker

  def scan_all_folders
    logger.info "About to scan all folders"
    
    for folder in MediaFolder.find_all_by_scan(true)
      logger.info "Scanning folder #{folder.location}"
      FolderScanner.find_content_in_folder(folder.location) do |file| 
        begin
          process_media_file(file, folder)
        rescue Exception => exception 
          logger.error("Error processing file #{file}:\n #{exception.class} (#{exception.message}):\n    " +
             exception.backtrace.join("\n    ") + "\n\n")
        end  
      end
    end
    
    logger.debug "Finished scanning all folders"
  end

  private
    def process_media_file(file, folder)
      logger.debug "Found media file: #{file}"
      reference = get_file_reference(file, folder)
      
      update_file_properties(reference) if reference.updated_at < File.mtime(file)
        
      if reference.video_content
        logger.debug "File already associated with #{reference.video_content.display_name} skipping"
        return
      end
      
      name_info = FileNameCleaner.get_name_info(file)
      logger.debug "Cleaned name: #{name_info}"
      #Check to see if we already have a matching video content
      video_content = find_video_content(name_info.name, name_info.year)
      if video_content
        logger.debug "Found match on existing video content #{video_content.display_name}"
        reference.video_content = video_content
        # TODO if tv show may have to associated this file with an episode
        reference.save!
        return
      end
      
      # Found new file for new content!
      if name_info.series || name_info.episode
        # If file name contains series and episode (e.g. E02S04) assume tv show 
        video_content = TvShow.new(:name => name_info.name, :year => name_info.year, 
                                   :state => VideoContentState::PENDING)
      else  
        video_content = Movie.new(:name => name_info.name, :year => name_info.year, 
                                  :state => VideoContentState::PENDING)
      end
      video_content.save!
      reference.video_content = video_content and reference.save!
      logger.info "Added new video content: #{video_content.id}"
      
      # Fire request to scrap imdb for new movie
      MiddleMan.worker(:scrap_imdb_worker).async_scrap_for_video_content(:arg => video_content.id)
    end
  
    def get_file_reference(location, folder)
      reference = VideoFileReference.find_by_location(location)
      return reference if reference
      logger.debug "New file references found, creating new mode"
      reference = VideoFileReference.new(:location => location, :media_folder => folder, :on_disk => true,
                                         :raw_name => FileNameCleaner.get_file_name(location))
      reference.save!
      update_file_properties(reference)
      return reference
    end
    
    def find_video_content(name, year)
      return VideoContent.find_by_name_and_year(name, year) if year
      return VideoContent.find_by_name(name)
    end
    
    def update_file_properties(reference)
      logger.debug "Updating file properties for #{reference.location}"
      existing_values = {}
      format = reference.format
      reference.video_file_properties.each { |i| existing_values[i.group + '-' + i.name] = i }
      MediaInfoUtil.get_media_info(reference.location).each_with_index do |info,index|
        info_params = {:group => info.group, :order => index, :name => info.key, :value => info.value}
        current = existing_values[info.group + '-' + info.key]
        if not current
          current = reference.video_file_properties.build(info_params)
          current.save!
        else
          current.update_attributes!(info_params)
        end
        #Pull out the most important property and set on the reference entity
        format = info.value if info.group == 'General' and info.key == 'Format'
      end
      reference.update_attribute(:format, format)
    end

end


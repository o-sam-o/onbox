require "lib/util/folder_scanner"
require "lib/util/file_name_cleaner"

class FolderScanWorker < BackgrounDRb::MetaWorker
  set_worker_name :folder_scan_worker

  def scan_all_folders
    logger.info "About to scan all folders"
    
    #TODO skip folders without the scan flag set
    for folder in MediaFolder.all
      logger.info "Scanning folder #{folder.location}"
      FolderScanner.find_content_in_folder(folder.location) do |file| 
        logger.debug "Found media file: #{file}"
        reference = get_file_reference(file, folder)
        if reference.video_content
          logger.debug "File already associated with #{reference.video_content.display_name} skipping"
          next
        end
        
        name_info = FileNameCleaner.get_name_info(file)
        logger.debug "Cleaned name: #{name_info}"
        #Check to see if we already have a matching video content
        video_content = find_video_content(name_info.name, name_info.year)
        if video_content
          logger.debug "Found match on existing video content #{video_content.display_name}"
          reference.video_content = video_content
          reference.save! and next
        end
        
        # Found new file for new content!
        video_content = VideoContent.new({:name => name_info.name, :year => name_info.year, :state => VideoContentState::PENDING})
        video_content.save!
        reference.video_content = video_content and reference.save!
        logger.info "Added new video content: #{video_content.id}"
        
        # Fire request to scrap imdb for new movie
        MiddleMan.worker(:scrap_imdb_worker).async_scrap_for_video_content(:arg => video_content.id)
      end
    end
    
    logger.debug "Finished scanning all folders"
  end

  private
    def get_file_reference(location, folder)
      reference = VideoFileReference.find_by_location(location)
      return reference unless not reference
      logger.debug "New file references found, creating new mode"
      reference = VideoFileReference.new({:location => location, :media_folder => folder, :on_disk => true,
                                          :raw_name => FileNameCleaner.get_file_name(location)})
      reference.save!
      return reference
    end
    
    def find_video_content(name, year)
      return VideoContent.find_by_name_and_year(name, year) unless not year
      return VideoContent.find_by_name(name)
    end

end


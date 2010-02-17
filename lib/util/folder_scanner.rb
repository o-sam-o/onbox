class FolderScanner
  MEDIA_REGEX = /.*\.(avi|mp4|mkv|m4v|mpg)$/ 

  def self.find_content_in_folder(root_folder)
    Dir.foreach(root_folder) do |file|
      next if %w[ . .. ].include?(file)

      file_path = "#{root_folder}/#{file}"
      self.find_content(file_path) {|file| yield file}
    end
  end

  private
    def self.find_content(file)
      if file =~ MEDIA_REGEX
        yield file
      elsif File.directory?(file)
        nfo = nil
        found_media = false
        Dir.foreach(file) do |subfile|
          subfile_path = "#{file}/#{subfile}"
          if subfile =~ /.*\.nfo$/
            nfo = subfile_path
          elsif subfile =~ MEDIA_REGEX and subfile !~ /.*sample.*/
            yield subfile_path
            found_media = true
          end
          #TODO handle sub sub folders, e.g. CD1 and CD2
        end
        # We only yield the nfo file if no media file was found,
        # in this scenario most likely the media is rar'ed
        yield nfo if nfo unless found_media
      end
    end

end
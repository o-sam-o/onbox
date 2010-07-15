module Util
  class FolderScanner
    MEDIA_REGEX = /.*\.(avi|mp4|mkv|m4v|mpg|mov|wmv)$/ 

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
            elsif subfile =~ MEDIA_REGEX && subfile !~ /.*sample.*/i
              yield subfile_path
              found_media = true
            elsif !%w[ . .. ].include?(subfile) && File.directory?(subfile_path)
              # Handle deeply nested media
              self.find_content(subfile_path) do |sub_folder_file|
                found_media = true
                yield sub_folder_file
              end
            end
          end
          # We only yield the nfo file if no media file was found,
          # in this scenario most likely the media is rar'ed
          yield nfo if nfo unless found_media
        end
      end

  end
end
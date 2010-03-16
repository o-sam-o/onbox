class TvEpisode < ActiveRecord::Base
  belongs_to :tv_show
  belongs_to :video_file_reference
end

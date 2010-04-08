class TvEpisode < ActiveRecord::Base
  belongs_to :tv_show
  belongs_to :video_file_reference
  
  def <=>(other)
    if other.series != self.series
      return self.series - other.series
    else
      return self.episode - other.episode
    end    
  end
  
end

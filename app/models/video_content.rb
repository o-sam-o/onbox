class VideoContent < ActiveRecord::Base
  validates_presence_of :name, :state
  has_many :video_file_references
  has_many :video_posters
end

class VideoContentState
  PENDING = :pending 
  PROCESSED = :processed
  NO_IMDB_ID = :no_imdb_id
  
  DISPLAY_NAMES = {:pending => "Pending", :processed => "Processed", :no_imdb_id => "Unknown Imdb Id"}
  
  def VideoContentState.display_name(value)
    value = value.intern unless value.kind_of? Symbol
    DISPLAY_NAMES[value]
  end
  
  def VideoContentState.select_values
    VALUES.map { |value| [VideoContentState.display_name(value), value.to_s]}
  end
  
  VALUES = [PENDING, PROCESSED, NO_IMDB_ID]
end

class VideoContentState
  PENDING = 'pending'
  PROCESSED = 'processed'
  NO_IMDB_ID = 'no_imdb_id'
  
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

class VideoContent < ActiveRecord::Base
  validates_presence_of :name, :state
  has_many :video_file_references
  has_many :video_posters
  validates_inclusion_of :state, :in => VideoContentState::VALUES
  
  def poster(size)
    return nil if not video_posters
    for poster in video_posters
      return poster if size.to_s == poster.size
    end
    return nil
  end
  
  def display_name
    display_name = self.name
    display_name += " (#{self.year})" if self.year
    return display_name
  end
end

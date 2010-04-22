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
  validates_uniqueness_of :imdb_id, :allow_nil => true, :allow_blank => true
  has_many :video_file_references
  has_many :video_posters, :dependent => :destroy 
  has_many :watches
  has_many :users, :through => :watches
  has_and_belongs_to_many :genres
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
  
  def runtime_formatted
    return '' if not runtime
    return "#{runtime}m" if runtime < 60
    return "#{runtime/60}h" if runtime % 60 == 0
    return "#{runtime/60}h #{runtime % 60}m"
  end
  
  def movie?
    false
  end
  
  def tv_show?
    false
  end
  
  def unique_imdb_id?(check_imdb_id)
    existing = VideoContent.find_by_imdb_id(check_imdb_id)
    return existing.nil? || existing.id == self.id
  end
  
  def merge_with_imdb_id(imdb_id)
    existing = VideoContent.find_by_imdb_id(imdb_id)
    
    # Move current file references to below to duplicate
    self.video_file_references.each do |file_ref|
      existing.video_file_references << file_ref
    end  
    self.video_file_references.clear
    
    existing.save!
    self.destroy
    
    return existing
  end   
end

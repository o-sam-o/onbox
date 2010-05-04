class VideoPoster < ActiveRecord::Base
  validates_presence_of :size, :location
  validates_uniqueness_of :location
  belongs_to :video_content
  validates_inclusion_of :size, :in => ['small', 'large']
  
  def self.poster_sizes
    return [['Small', 'small'], ['Large', 'large']]
  end
  
end
class VideoPosterSize
  SMALL = 'small' 
  LARGE = 'large'
  
  DISPLAY_NAMES = {:small => "Small", :large => "Large"}
  
  def VideoPosterSize.display_name(value)
    value = value.intern unless value.kind_of? Symbol
    DISPLAY_NAMES[value]
  end
  
  def VideoPosterSize.select_values
    VALUES.map { |value| [VideoPosterSize.display_name(value), value.to_s]}
  end
  
  VALUES = [SMALL, LARGE]
end

class VideoPoster < ActiveRecord::Base
  validates_presence_of :size, :location
  belongs_to :video_content
  validates_inclusion_of :size, :in => VideoPosterSize::VALUES
end
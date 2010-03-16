class TvShow < VideoContent
  has_many :tv_episodes
  
  def tv_show?
    true
  end  
end

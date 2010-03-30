class TvShow < VideoContent
  has_many :tv_episodes, :order => 'series, episode' do
    def group_by_series
      result = {}
      self.each do |episode|
        result[episode.series] = [] unless result[episode.series]
        result[episode.series] << episode
      end  
      return result
    end  
  end  
  
  def tv_show?
    true
  end  
end

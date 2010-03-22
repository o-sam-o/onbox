class FixSeriesInTvEpisode < ActiveRecord::Migration
  def self.up
    rename_column :tv_episodes, :serie, :series
    remove_column :tv_episodes, :tv_episode_id
    add_column :tv_episodes, :tv_show_id, :integer
  end

  def self.down
    rename_column :tv_episodes, :series, :serie
    remove_column :tv_episodes, :tv_show_id
    add_column :tv_episodes, :tv_episode_id, :integer    
  end
end

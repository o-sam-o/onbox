class CreateTvEpisodes < ActiveRecord::Migration
  def self.up
    create_table :tv_episodes do |t|
      t.string :title
      t.string :plot
      t.integer :serie
      t.integer :episode
      t.date :date
      t.references :video_file_reference
      t.references :tv_episode

      t.timestamps
    end
  end

  def self.down
    drop_table :tv_episodes
  end
end

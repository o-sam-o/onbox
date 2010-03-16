class ConvertVideoContentToSti < ActiveRecord::Migration
  def self.up
    #Delete references as the may references already existing video contents
    execute 'delete from video_file_references'
    
    drop_table :video_contents
    
    create_table :video_contents do |t|
      t.string   :name
      t.integer  :year
      t.string   :plot
      t.string   :state
      t.string   :imdb_id
      t.string   :language
      t.string   :tag_line
      t.integer  :runtime

      #Movie specific
      t.date     :release_date     
      t.string   :director      
      
      t.string   :type
            
      t.timestamps
    end    
  end

  def self.down
    drop_table :video_contents
    
    create_table :video_contents do |t|
      t.string   :name
      t.integer  :year
      t.date     :release_date
      t.string   :plot
      t.string   :state
      t.string   :imdb_id
      t.integer  :runtime
      t.string   :director
      t.string   :language
      t.string   :tag_line
      
      t.timestamps
    end    
  end
end

class BulkChangeVideoContentsController < ApplicationController
  before_filter :require_user
      
  def search
    if params['search'].present?
      @search_results = VideoFileReference.all(:conditions => ["location LIKE ?", "%#{params[:search]}%"])
    end  
  end
  
  def bulk_edit
    if params['video_content_ids'].nil? || params['video_content_ids'].empty?
      flash[:error] = "No videos selected"
      redirect_to bulk_change_search_path(:search => params['search'])
    end      
  end  
  
  def bulk_update
    #Update imdb_id for selected items, the first will be changed, others will be merged
    params['video_content_ids'].each do |video_content_id|
      video_content = VideoContent.find(video_content_id)
      if video_content.unique_imdb_id?(params[:imdb_id])
        video_content.imdb_id = params[:imdb_id]
        # If the imdb id changes any existing poster are invalid
        video_content.video_posters.clear
        video_content.save!
      else
        video_content = video_content.merge_with_imdb_id(params[:imdb_id])
      end    
    end
    
    # This is a good time to refresh
    video_content = VideoContent.first(:conditions => ['imdb_id = ?', params[:imdb_id]])
    video_content.state = VideoContentState::PENDING
    video_content.save!
    
    begin
      MiddleMan.worker(:scrap_imdb_worker).async_scrap_for_video_content(:arg => video_content.id)
    rescue
      logger.error "Error kicking off reload for imdb id: #{params[:imdb_id]} - #{$!}"
    end
    
    flash[:notice] = "Bulk updated #{params['video_content_ids'].size} video imdb ids to #{params[:imdb_id]}"
    redirect_to(video_content)      
  end
  
end      
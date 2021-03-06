class VideoContentsController < ApplicationController
  before_filter :require_user, :except => [:show, :index]
  before_filter :find_video_content,
      :only => [:show, :edit, :update, :destroy, :reload, :watch]
      
  def index
    @page, offset = page_and_offset
    @video_contents = VideoContent.all(:limit => ONBOX_CONFIG[:default_table_size], :offset => offset, :order => "name")
    @video_content_count = VideoContent.count
    
    respond_to do |format|
      format.html # index.html.erb
      format.json  { render :json => @video_contents.to_json(:include => :video_posters) }
    end    
  end

  def auto_complete
    @video_contents = VideoContent.find(:all, :conditions => ['name LIKE ?', "%#{params[:search]}%"])
  end

  def search_imdb
    @search_results = YayImdbs.search_imdb(params[:search_term])
    render 'video_contents/search_imdb.html', :layout => false
  end  

  def new
    @video_content = VideoContent.new
    render 'video_contents/save'
  end

  def edit
    render 'video_contents/save'
  end

  def show
    @watched = current_user ? current_user.watched?(@video_content) : false
  end

  # Refresh metadata from imdb, also allows the changing of the imdb id 
  def reload
    if params[:imdb_id].present? && params[:imdb_id] != @video_content.imdb_id
      if @video_content.unique_imdb_id?(params[:imdb_id])
        @video_content.imdb_id = params[:imdb_id]
        # If the imdb id changes any existing poster are invalid
        @video_content.video_posters.clear
      else
        @video_content = @video_content.merge_with_imdb_id(params[:imdb_id])
      end  
    end  
    
    @video_content.state = 'pending'
    @video_content.save!
    
    MiddleMan.worker(:scrap_imdb_worker).async_scrap_for_video_content(:arg => @video_content.id)
    
    flash[:notice] = "#{@video_content.name} refreshing from IMDB.  Please wait a little while and then refresh the page"
    redirect_to(@video_content)    
  rescue
    flash[:error] = "Error refreshing video: #{$!}"
    redirect_to(@video_content)
  end

  def create
    if params[:video_content][:type] == 'Movie'
      @video_content = Movie.new(params[:video_content])
    elsif params[:video_content][:type]  == 'TvShow'
      @video_content = TvShow.new(params[:video_content])
    else
      raise "Unknown video content type #{params[:video_content][:type] }"
    end  

    if @video_content.save
      flash[:notice] = "#{@video_content.name} was successfully created."
      redirect_to(@video_content)
    else
      render 'video_contents/save'
    end
  end
  
  def update
    update_params = params[:video_content]
    update_params = params[:movie] if @video_content.movie?
    update_params = params[:tv_show] if @video_content.tv_show?
    if update_params[:type] != @video_content.type
      logger.info "Changing item type from #{@video_content.type} to #{update_params[:type]}"
      @video_content.change_type(update_params[:type])
    end  
    
    if @video_content.update_attributes(update_params)
      # Reload if type changed to ensure class type is changed
      @video_content = VideoContent.find(params[:id]) if update_params[:type] != @video_content.type
      
      flash[:notice] = "#{@video_content.name} was successfully updated."
      redirect_to(@video_content)
    else
      render 'video_contents/save'
    end    
  end

  def watch
    if params[:watched] == 'true'
      current_user.has_watched(@video_content)
    else
      current_user.has_not_watched(@video_content)
    end  
    
    render :json => true
  end  

  def destroy
    flash[:notice] = "#{@video_content.name} was removed."
    @video_content.destroy
    redirect_to(video_contents_url)
  end    

  private
    def find_video_content
      @video_content = VideoContent.find(params[:id])
    end
end

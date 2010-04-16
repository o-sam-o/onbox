class VideoPostersController < ApplicationController
  before_filter :require_user, :except => [:show]
  
  before_filter :find_video_content
  before_filter :find_video_poster,
      :only => [:show, :edit, :update, :destroy]
      
  def index
    @video_posters = @video_content.video_posters

    respond_to do |format|
      format.html # index.html.erb
      format.json  { render :json => @video_posters }
    end    
  end

  def new
    @video_poster = @video_content.video_posters.build
    render 'video_posters/save'
  end

  def show
      if not File.exists?(ONBOX_CONFIG[:poster_storage] + @video_poster.location)
        logger.error "Unable to find poster: #{ONBOX_CONFIG[:poster_storage]}#{@video_poster.location} for video content #{@video_content.id}"
        render :status => 404 and return
      end
      send_file ONBOX_CONFIG[:poster_storage] + @video_poster.location, :disposition => 'inline', :type => 'image/jpeg'
  end

  def edit
    render 'video_posters/save'
  end

  def create
    @video_poster = @video_content.video_posters.build(params[:video_poster])

    if @video_poster.save
      flash[:notice] = "Video poster '#{@video_poster.location}' was successfully created."
      redirect_to(video_content_video_posters_path(@video_content))
    else
      render 'video_posters/save'
    end
  end
  
  def update
    if @video_poster.update_attributes(params[:video_poster])
      flash[:notice] = "Video poster '#{@video_poster.location}' was successfully updated."
      redirect_to(video_content_video_posters_path(@video_content))
    else
      render 'video_posters/save'
    end    
  end

  def destroy
    flash[:notice] = "Video poster '#{@video_poster.location}' was removed."
    @video_poster.destroy
    redirect_to(video_content_video_posters_path(@video_content))
  end    

  private
    def find_video_content
      @video_content = VideoContent.find(params[:video_content_id])
    end
    
    def find_video_poster
      @video_poster = VideoPoster.find(params[:id])
    end  
end

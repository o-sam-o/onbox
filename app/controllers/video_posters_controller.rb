class VideoPostersController < ApplicationController
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
  end

  def edit
    render 'video_posters/save'
  end

  def create
    @video_poster = @video_content.video_posters.build(params[:video_poster])

    if @video_poster.save
      flash[:notice] = 'Video poster was successfully created.'
      redirect_to(@video_content)
    else
      render 'video_posters/save'
    end
  end
  
  def update
    if @video_content.update_attributes(params[:video_content])
      flash[:notice] = 'Video poster was successfully updated.'
      redirect_to(@video_content)
    else
      render 'video_posters/save'
    end    
  end

  def destroy
    @video_poster.destroy
    redirect_to(video_contents_url)
  end    

  private
    def find_video_content
      @video_content = VideoContent.find(params[:video_content_id])
    end
    
    def find_video_poster
      @video_poster = VideoPoster.find(params[:id])
    end  
end

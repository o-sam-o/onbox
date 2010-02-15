class VideoContentsController < ApplicationController
  before_filter :find_video_content,
      :only => [:show, :edit, :update, :destroy]
      
  def index
    @video_contents = VideoContent.all

    respond_to do |format|
      format.html # index.html.erb
      format.json  { render :json => @video_contents.to_json(:include => :video_posters) }
    end    
  end

  def new
    @video_content = VideoContent.new
    render 'video_contents/save'
  end

  def edit
    render 'video_contents/save'
  end

  def show
  end

  def create
    @video_content = VideoContent.new(params[:video_content])

    if @video_content.save
      flash[:notice] = "#{@video_content.name} was successfully created."
      redirect_to(@video_content)
    else
      render 'video_contents/save'
    end
  end
  
  def update
    if @video_content.update_attributes(params[:video_content])
      flash[:notice] = "#{@video_content.name} was successfully updated."
      redirect_to(@video_content)
    else
      render 'video_contents/save'
    end    
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

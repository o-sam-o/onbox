class VideoFileReferencesController < ApplicationController
  before_filter :find_reference,
      :only => [:show, :edit, :update, :destroy]
  
  auto_complete_for :video_content, :name
  
  def index
    @references = VideoFileReference.all
  end

  def new
    @reference = VideoFileReference.new
    render 'video_file_references/save'
  end

  def edit
    render 'video_file_references/save'
  end

  def show
  end

  def create
    @reference = VideoFileReference.new(params[:video_file_reference])
    @reference.valid?
    set_video_content
    if @reference.errors.empty? and @reference.save
      flash[:notice] = "'#{@reference.location}' was successfully created."
      redirect_to(video_file_references_url)
    else
      render 'video_file_references/save'
    end
  end
  
  def update
    @reference.attributes = params[:video_file_reference]
    @reference.valid?
    set_video_content
    if @reference.errors.empty? and @reference.save()
      flash[:notice] = "'#{@reference.location}' was successfully updated."
      redirect_to(video_file_references_url)
    else
      render 'video_file_references/save'
    end    
  end

  def destroy
    flash[:notice] = "'#{@reference.location}' was removed."    
    @reference.destroy
    redirect_to(video_file_references_url)
  end

  private
    def find_reference
      @reference = VideoFileReference.find(params[:id])
    end
    
    def set_video_content
      name = params[:video_content][:name]
      if name.blank?
        @reference.video_content = nil
      else
        video = VideoContent.find_by_name(name)
        if video
          @reference.video_content = video
        else
          @reference.errors.add :video_content_name, "Unable to find video #{name}"
          return false
        end  
      end  
      return true
    end
end

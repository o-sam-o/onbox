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

    if @reference.save
      flash[:notice] = "'#{@reference.location}' was successfully created."
      redirect_to(video_file_references_url)
    else
      render 'video_file_references/save'
    end
  end
  
  def update
    if @reference.update_attributes(params[:video_file_reference])
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
end

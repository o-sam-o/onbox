class MediaFoldersController < ApplicationController
  before_filter :require_user
  before_filter :find_media_folder,
      :only => [:show, :edit, :update, :destroy]  
  
  def index
    @media_folders = MediaFolder.all
  end

  def new
    @media_folder = MediaFolder.new
    render 'media_folders/save'
  end

  def show
  end

  def edit
    render 'media_folders/save'
  end

  def create
    @media_folder = MediaFolder.new(params[:media_folder])

    if @media_folder.save
      flash[:notice] = "'#{@media_folder.location}' was successfully created."
      redirect_to(media_folders_url)
    else
      render 'media_folders/save'
    end
  end
  
  def update
    if @media_folder.update_attributes(params[:media_folder])
      flash[:notice] = "'#{@media_folder.location}' was successfully updated."
      redirect_to(media_folders_url)
    else
      render 'media_folders/save'
    end    
  end

  def destroy
    flash[:notice] = "'#{@media_folder.location}' was deleted."
    @media_folder.destroy
    redirect_to(media_folders_url)
  end

  private
    def find_media_folder
      @media_folder = MediaFolder.find(params[:id])
    end

end

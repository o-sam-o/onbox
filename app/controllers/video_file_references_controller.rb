class VideoFileReferencesController < ApplicationController
  before_filter :require_user
  before_filter :find_reference,
      :only => [:show, :edit, :update, :destroy]
  
  auto_complete_for :video_content, :name
  
  def index
    @page, offset = page_and_offset
    @references = VideoFileReference.all(:limit => ONBOX_CONFIG[:default_table_size], :offset => offset, :order => "raw_name")
    @reference_count = VideoFileReference.count
  end

  def new
    @reference = VideoFileReference.new
    render 'video_file_references/save'
  end

  def edit
    render 'video_file_references/save'
  end

  def show
    if not File.exists?(@reference.location)
      logger.error "Unable to find file: #{@reference.location} for reference #{@reference.id}"
      render :status => 404 and return
    end
    send_file @reference.location, :type => 'video/' + @reference.format.downcase     
  end

  def create
    @reference = VideoFileReference.new(params[:video_file_reference])
    @reference.valid?
    set_video_content
    if @reference.errors.empty? && @reference.save
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
    if @reference.errors.empty? && @reference.save()
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

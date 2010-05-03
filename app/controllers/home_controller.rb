class HomeController < ApplicationController
  CAROUSEL_WIDTH = 5
  CAROUSEL_HEIGHT = 3
  
  before_filter :extract_criteria
  
  verify :params => ['offset', 'page_size'], :only => :video_content_items
  
  public :render_to_string
  
  def index
    if @unwatched && !current_user
      store_location
      redirect_to login_path
      return
    end  
    @video_content_count = VideoContent.count(:joins => search_joins, :conditions => search_conditions, :select => 'distinct video_contents.id')
    @video_contents = search
  end
  
  def video_content_items
    @video_contents = search(params[:offset], params[:page_size])
  end

  private
    def search(offset = 0, limit = (CAROUSEL_WIDTH * CAROUSEL_HEIGHT))
      VideoContent.all(:limit => limit, :offset => offset, 
                       :conditions => search_conditions,
                       :select => 'distinct video_contents.*',
                       :joins => search_joins, :order => "video_contents.name")
    end
  
    def extract_criteria
      @genres = params[:criteria].dup rescue []
      @unwatched = @genres.delete('unwatched').present?
      @video_type = 'Movie' if @genres.delete('movie').present?
      @video_type = 'TvShow' if @genres.delete('tvshow').present?
    end  
  
    def search_conditions
      query, args = [], []

      if @unwatched && current_user
        query << 'video_contents.id not in (select video_content_id from watches where user_id = ?)' 
        args << current_user
      end
      
      unless @genres.empty?
        query << 'genres.id in (?)'
        args << @genres.collect { |name| Genre.find(:first, :conditions=>['LOWER(name) = ?', name.downcase])  }
      end 
      
      unless params[:q].blank?
        query << 'video_contents.name like ?'
        args << "%#{params[:q]}%"
      end  
      
      if @video_type
        query << 'video_contents.type = ?'
        args << @video_type
      end      
      
      return query ? [query.join(' and '), *args] : []
    end

    def search_joins
      return [:genres] unless @genres.empty?
    end

end

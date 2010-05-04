class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  
  before_filter :base_layout_load
  
  protect_from_forgery
  filter_parameter_logging :password, :password_confirmation
  
  helper_method :current_user_session, :current_user
  
  private
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end
    
    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.record
    end
    
    def require_user
      unless current_user
        store_location
        flash[:notice] = "You must be logged in to access this page"
        redirect_to login_url
        return false
      end
    end

    def store_location
      session[:return_to] = request.request_uri
    end
    
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end

    def page_and_offset
      offset = 0
      page = 1
      if params[:page]
        page = params[:page].to_i
        offset = (page - 1) * ONBOX_CONFIG[:default_table_size]
      end
      return page, offset
    end
    
    # Load content needed by application layout
    def base_layout_load 
      all_genres = Genre.all(:order => 'name')
      col_length = all_genres.length / 3
      if col_length < 1
        @genres_column_1 = all_genres
      else
        @genres_column_1 = all_genres[0..col_length]
        @genres_column_2 = all_genres[(col_length + 1)..(col_length*2)]
        @genres_column_3 = all_genres[((col_length*2) + 1)..all_genres.length]
      end  
    end  
end

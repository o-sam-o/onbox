# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  private
    def page_and_offset
      offset = 0
      page = 1
      if params[:page]
        page = params[:page].to_i
        offset = (page - 1) * ONBOX_CONFIG[:default_table_size]
      end
      return page, offset
    end
end

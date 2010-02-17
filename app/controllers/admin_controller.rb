class AdminController < ApplicationController
  def index
  end
  
  def scan_all_folders
    begin
      MiddleMan.worker(:folder_scan_worker).async_scan_all_folders
      flash[:notice] = "Started all folders scan."
    rescue
      flash[:error] = "Error starting scan: #{$!}"
      logger.error "Error scanning all folders: #{$!}"
    end
    redirect_to(:action => :index)
  end
  
  def scrap_pending
    begin
      MiddleMan.worker(:scrap_imdb_worker).async_scrap_all_pending
      flash[:notice] = "Started scrap pending."
    rescue
      flash[:error] = "Error starting scrap: #{$!}"
      logger.error "Error scraping all pending: #{$!}"
    end
    redirect_to(:action => :index)
  end  

end

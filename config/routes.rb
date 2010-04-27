ActionController::Routing::Routes.draw do |map|
  map.root :controller => "home"
  
  # Admin specific resources
  map.resources :media_folders, :path_prefix => 'admin'
  map.resources :users, :path_prefix => 'admin'
  
  map.admin 'admin/:action', :controller => 'admin'

  map.bulk_change_search 'video_contents/bulk/search', :controller => 'bulk_change_video_contents', :action => 'search'
  map.bulk_change 'video_contents/bulk/:action', :controller => 'bulk_change_video_contents'

  map.resources :video_file_references
  map.resources :video_contents, :member => {:auto_complete => :get, :reload => :post, :watch => :post, :search_imdb => :get}, :has_many => :video_posters
  map.resources :movies, :controller => 'video_contents'
  map.resources :tv_shows, :controller => 'video_contents', :has_many => :tv_episodes

  map.login 'login', :controller => 'user_sessions', :action => 'new'
  map.resource :user_session

  map.home_carousel 'home/carousel/*criteria', :controller => "home", :action => 'video_content_items'

  map.home_search 'home/*criteria', :controller => "home"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
end

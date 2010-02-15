ActionController::Routing::Routes.draw do |map|
  map.root :controller => "home"
    
  map.connect 'video_contents/auto_complete', :controller => 'video_contents', :action => 'auto_complete'
  
  map.resources :media_folders, :video_contents, :video_file_references, :video_posters
  map.resources :video_contents, :has_many => :video_posters

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end

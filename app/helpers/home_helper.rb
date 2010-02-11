module HomeHelper
  
  def render_to_string(*args)
    controller.render_to_string(*args)
  end
  
end

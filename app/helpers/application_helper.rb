module ApplicationHelper
  def sidebar_closed? 
    session[:sidebar_state] == 'closed'
  end

  def current_sidebar_expanded?
    session[:sidebar_state] == 'expanded'
  end
end

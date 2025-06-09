module ApplicationHelper
  def sidebar_closed? 
    session[:sidebar_state] == 'closed'
  end

  def current_sidebar_expanded?
    session[:sidebar_state] == 'expanded'
  end

  def bootstrap_class_for(flash_type)
    case flash_type.to_sym
    when :notice then "success"
    when :alert  then "danger"
    else "info"
    end
  end
end

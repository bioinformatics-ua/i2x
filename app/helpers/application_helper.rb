module ApplicationHelper


  ##
  # => Highlight variables for UI
  #
  def highlight_variables(text)
    # Based on ActionView::Helpers::TextHelper#highlight
    highlighter = '<span class="selector">\1</span>'
    matcher = /%{(.*?)}/
    text.gsub(matcher, highlighter).html_safe
  end
  
  ##
  # => Automating tabindex counts
  #
  def autotab
    @current_tab ||= 0
    @current_tab += 1
  end

  ##
  # => Making Devise login/registration available everywhere
  #
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def resource_class
    devise_mapping.to
  end
end
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
end
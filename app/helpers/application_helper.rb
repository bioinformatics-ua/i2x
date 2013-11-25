module ApplicationHelper
  
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
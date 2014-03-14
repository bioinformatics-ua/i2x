class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  before_filter :configure_devise_params, if: :devise_controller?
  skip_before_filter :verify_authenticity_token


  ##
  # => Allow more parameters to user details
  #
  def configure_devise_params
  	devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :username, :email, :password, :password_confirmation, :remember_me) }
  	devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:name, :login, :username, :email, :password, :remember_me) }
  	devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:name, :username, :email, :password, :password_confirmation, :current_password) }
  end

  def default_url_options
  	if Rails.env.production?
  		{
  			:host => "bioinformatics.ua.pt",
  			:protocol => 'https://'
  		}
  	else  
  		{}
  	end
  end

end
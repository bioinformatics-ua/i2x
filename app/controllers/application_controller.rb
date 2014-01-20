class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  before_filter :generate_content
  before_filter :configure_devise_params, if: :devise_controller?
  skip_before_filter :verify_authenticity_token



  ##
  # => Read the raw content for documentations
  #
  def generate_content
    begin
      @content = Kramdown::Document.new(File.read('raw/i2x_' + controller_name + '_' + action_name + '.md'), :toc_levels => '1').to_html
    rescue
    end
  end

  ##
  # => Allow more parameters to user details
  #
  def configure_devise_params
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:name, :email, :password, :password_confirmation)
    end
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
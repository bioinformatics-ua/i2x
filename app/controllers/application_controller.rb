class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter	:generate_content

  def generate_content
  	begin
  		@content = Kramdown::Document.new(File.read('raw/i2x_' + controller_name + '_' + action_name + '.md')).to_html
  	rescue
  	end
  end

end

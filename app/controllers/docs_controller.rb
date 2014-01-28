class DocsController < ApplicationController
	layout "documentation"

	def show
		generate_content params[:section], params[:topic]
	end

	def index
		generate_content 'reference', 'index'
	end

	  ##
  # => Read the raw content for documentations
  #
  def generate_content(section, topic)
  	begin
  		@content = Kramdown::Document.new(File.read('data/docs/i2x_' + section + '_' + topic + '.md'), :toc_levels => '1').to_html
  	rescue
  	end
  	@content
  end
end

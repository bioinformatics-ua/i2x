class DocumentationController < ApplicationController
  layout "documentation"

  def index
  	redirect_to :controller => 'reference', :action => 'index', status: :moved_permanently
  end
end

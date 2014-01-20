require 'cashier'

class FluxCapacitorController < ApplicationController
	#before_filter :authenticate_user!
	respond_to :json

	##
	# => Generate new API key for authenticated user
	#
	def generate_key
		begin
			ak = ApiKey.create!
			current_user.api_keys.push ak
			ak.save
			current_user.save
			response = {:status => 100, :access_token => ak.access_token}
		rescue Exception => e
			response = {:status => 400}
			Services::Slog.exception e
		end

		respond_to do |format|
			format.json  {
				render :json => response
			}
		end
	end

	##
	# => Remove given API key for authenticated user.
	#
	def remove_key
		begin
			current_user.api_keys.find_by_access_token(params[:access_token]).destroy
			current_user.save
			response = {:status => 100, :access_token => params[:access_token]}
		rescue Exception => e
			response = {:status => 400}
			Services::Slog.exception e
		end
		respond_to do |format|
			format.json  {
				render :json => response
			}
		end
	end

	  ##
	  # => [API] verify if content exists in cache. 
	  # 
	  # - API key must exist in database. Parameter: *access_token*
	  # - Agent must belong to API key user. Parameter: *agent*
	  # - Agent must be configured in integration, with template.
	  # - Returns array of template identifiers.
	  #
	  def verify
	  	begin
	  		api_key = ApiKey.find_by_access_token(params[:access_token])
	  		unless api_key.nil? then
	  			user = api_key.user
	  			agent = user.agents.find_by_identifier(params[:agent])
	  			@cache = Services::Cashier.verify params[:memory], agent, params[:payload], params[:seed]
	  			@templates = Array.new
	  			agent.integrations.each do |integration|
	  				integration.templates.each do |template|
	  					@templates.push template.identifier
	  				end
	  			end
	  			respond_to do |format|
	  				format.json  {
	  					render :json => {:cache => @cache, :templates => @templates}
	  				}
	  			end
	  		end
	  	rescue Exception => e
	  		Services::Slog.exception e
	  	end
	  	render(:file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => false)
	  end

	  def validate_key
	  	begin
	  		api_key = ApiKey.find_by_access_token(params[:access_token])
	  		head :unauthorized unless api_key
	  		response = {:status => 100, :access_token => api_key.access_token}
	  	rescue Exception => e
	  		Services::Slog.exception e
	  	end

	  	respond_to do |format|
	  		format.json  {
	  			render :json => response
	  		}
	  	end
	  end


	end

require 'cashier'

class FluxCapacitorController < ApplicationController
	#before_filter :authenticate_user!
	#respond_to :json

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
	  			@cache = Services::Cashier.verify params[:cache], agent, params[:payload], params[:seed]
	  			if @cache[:status] == 100 then
	  				@templates = Array.new
	  				agent.integrations.each do |integration|
	  					integration.templates.each do |template|
	  						@templates.push template.identifier
	  					end
	  				end
	  			end	  			
	  		end
	  	rescue Exception => e
	  		Services::Slog.exception e
	  		render(:file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => false)
	  	end
	  	respond_to do |format|
	  		format.json  {
	  			render :json => {:cache => @cache, :templates => @templates}
	  		}
	  	end
	  end

	  ##
	  # => Generate sample client code for user API key.
	  #
	  def generate_client
	  	@client = File.read("data/clients/sample_client.js").to_str
	  	@client['%{host}'] = ENV["APP_HOST"]
	  	@client['%{name}'] = ENV["APP_TITLE"]
	  	@client['%{access_token}'] = (params[:access_token].nil? ? '<access_token>' : params[:access_token])
	  	respond_to do |format|
	  		format.json  {
	  			render :json => @client
	  		}
	  	end
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

	  def ping
	  	response = {:pong => params[:ping]}
	  	respond_to do |format|
	  		format.json  {
	  			render :json => response
	  		}
	  		format.xml  {
	  			render :xml => response
	  		}
	  		format.js  {
	  			render :json => response
	  		}
	  	end
	  end

	  ## Agents API
	  def agent_update_meta
	  	@agent = Agent.find(params[:id])
	  	agent_params.each do |k,v|
	  		@agent[k] = v	  		
	  	end
	  	respond_to do |format|
	  		if @agent.save
	  			format.json  {
	  				render :json => {:status => 100}
	  			}
	  		end
	  	end


	  end

	  def agent_params
	  	params.permit(:publisher, :payload, :identifier, :title, :help, :schedule, :seed, :uri, :cache, :headers, :delimiter, :checked ,:server, :host, :port, :database, :username, :password, :query, :selectors, :last_check_at, :events_count)
	  end

	end

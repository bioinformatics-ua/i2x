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

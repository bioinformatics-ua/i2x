class FilesController < ApplicationController
	before_filter :authenticate_user!

	def get		
		begin
			send_file "data/users/#{current_user.id}/#{params[:filename]}.#{params[:format]}",
			:filename => "#{params[:filename]}.#{params[:format]}"		
		rescue Exception => e
			Services::Slog.exception e
		end
	end

	def delete	
		begin
			File.delete("data/users/#{current_user.id}/#{params[:filename]}.#{params[:format]}")
		rescue Exception => e
			Services::Slog.exception e
		end
		redirect_to action: 'index'
	end

	def index
		@events = Event.by_user_limit current_user
		@files = Dir["data/users/#{current_user.id}/*"]	
	end
end

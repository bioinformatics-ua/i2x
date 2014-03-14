class RegistrationsController < Devise::RegistrationsController
	after_filter :create_folder, :only => :create

	def new
		super
	end

	def update
		super
	end

	def create
		super
	end

	##
	# = Create Folder
	#
	# => Creates new folder to store file data for each user (files from "File" templates). 
	def create_folder
		begin
			Dir.mkdir(Pathname.new(Rails.root.to_s + '/data/users/') + resource.id.to_s)  
			Services::Slog.debug({:message => "New user registration", :module => "RegistrationsController", :task => "user_registration", :extra => {:user => resource}})              
		rescue Exception => e
			Services::Slog.exception e
		end
	end
end
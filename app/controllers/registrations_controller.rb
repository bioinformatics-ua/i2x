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

	def create_folder
		begin
    		path =  Pathname.new(Rails.root.to_s + '/data/users/') #=> Note 1
    		directory_name = resource.id.to_s     
    		puts directory_name           #=> Note 2
    		Dir.mkdir(path + directory_name)                #=> Note 3
		rescue Exception => e
			puts e
		end
	end
end
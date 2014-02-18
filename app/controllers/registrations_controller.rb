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
    		Dir.mkdir(Pathname.new(Rails.root.to_s + '/data/users/') +resource.id.to_s)                #=> Note 3
    	rescue Exception => e
    		Services::Slog.exception e
    	end
    end
end
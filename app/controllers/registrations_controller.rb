class RegistrationsController < Devise::RegistrationsController
  after_filter :create_folder, :only => :create

  def new
    super
  end

  def update
    super
  end

  def create_folder
    path =  Pathname.new(Rails.root.to_s + '/data/users/') #=> Note 1
    directory_name = resource.id.to_s                #=> Note 2
    Dir.mkdir(path + directory_name)                #=> Note 3
  end
end
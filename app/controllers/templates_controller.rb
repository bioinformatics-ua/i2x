class TemplatesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_template, only: [:show, :edit, :update, :destroy]

  # GET /templates
  # GET /templates.json
  def index
    @templates =  current_user.templates
    @events = Event.by_user_limit current_user
  end

  # GET /templates/1
  # GET /templates/1.json
  def show
    begin
      @template = current_user.templates.find(params[:id])
    rescue Exception => e
      flash[:notice] = "You are not authorized to access that Template"
      Services::Slog.exception e
      redirect_to :root
    end
  end

  # GET /templates/new
  def new
    @template = Template.new
    if request.post? then
      puts params[:message]
      attrs = JSON.parse(params[:message])
      @template = Template.create! attrs
      @template.status = 100
      @template.count = 0
      if @template.save
        current_user.templates.push(@template)
        current_user.save
        response = { :status => 200, :message => "[i2x]: template #{params[:identifier]} loaded", :id => @template[:id] }
      end
      respond_to do |format|
        #format.html { redirect_to templates_url }
        #format.json { render :json => response}
        format.json { render json: @template, status: :created }
        format.js { render json: @template, status: :created }
      end
    else
    end

  end

  # GET /templates/1/edit
  def edit
  end

  # POST /templates
  # POST /templates.json
  def create
    @template = Template.new(template_params)
    @template.last_execute_at = nil
    @template.status = 100
    @template.count = 0
    respond_to do |format|
      if @template.save
        current_user.templates.push(@template)
        current_user.save
        #format.html { redirect_to @template, notice: 'Template was successfully created.' }
        #format.json { render action: 'show', status: :created, location: @template }
        format.json { render json: @template, status: :created }
      else
        format.html { render action: 'new' }
        format.json { render json: @template.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /templates/1
  # PATCH/PUT /templates/1.json
  def update
    puts template_params
    respond_to do |format|
      if @template.update(template_params)
        format.html { redirect_to @template, notice: 'Template was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /templates/1
  # DELETE /templates/1.json
  def destroy
    current_user.templates.delete(@template)
        # Remove from integrations
        @template.integrations.each do |integration|
          integration.templates.delete(@template)

      # check if integrations has agents, remove if all empty
      if integration.agents.empty?
        current_user.integrations.delete(integration)
        integration.destroy
      end
    end
    @template.destroy
    respond_to do |format|
      format.html { redirect_to templates_url }
      format.json { head :no_content }
    end
  end

  def start
    @template = Template.new
    if request.post? then
      puts params[:message]
      attrs = JSON.parse(params[:message])
      @template = Template.create! attrs
      response = { :status => 200, :message => "[i2x]: template #{params[:identifier]} loaded", :id => @template[:id] }
      respond_to do |format|
        format.html { redirect_to templates_url }
        format.json { render :json => response}
      end
    else
    end
  end

  def get
    begin
      @template = Template.find(params[:identifier])

      respond_to do |format|
        format.json { render :json => @template}
        format.xml { render :xml => @template}
      end
    rescue Exception => e
      Services::Slog.exception e
    end
  end

  ##
  # => Add existing sample templates to user.
  #
  def add
    @object = JSON.parse(File.read("data/templates/#{params[:identifier]}.js"))
    @object['identifier'] = "#{@object['identifier']}_#{current_user.id}"
    @template = Template.create! @object
    @template.identifier = "#{@template.id}_#{@template.identifier}"
    @template.status = 100
    @template.count = 0

    current_user.templates.push @template
    respond_to do |format|
      format.html { redirect_to @template }
    end if @template.save
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_template
    begin
      @template = Template.find(params[:id])
    rescue Exception => e
      Services::Slog.exception e
      flash[:notice] = "Sorry, <i class=\"icon-shuffle\"></i> couldn't find the template identified by <em>#{params[:id]}</em>."
      redirect_to :controller => "templates", :action => "index"
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def template_params
    params.require(:template).permit(:identifier, :title, :help, :publisher, :variables, :payload, :memory, :count, :last_execute_at, :created_at, :updated_at, :method, :content,:uri, :cache, :checked, :headers, :delimiter, :host, :port, :database, :username, :password, :query, :selectors, :server, :to, :cc, :bcc, :subject, :message)
  end
end

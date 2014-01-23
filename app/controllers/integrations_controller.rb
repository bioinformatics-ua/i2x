class IntegrationsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_integration, only: [:show, :edit, :update, :destroy]

  # GET /integrations
  # GET /integrations.json
  def index
    @integrations = current_user.integrations
    @events = Event.by_user_limit current_user
  end

  # GET /integrations/1
  # GET /integrations/1.json
  def show
    begin
      @integration = current_user.integrations.find(params[:id])
    rescue Exception => e
      flash[:notice] = "You are not authorized to access that Integration"
      Services::Slog.exception e
      redirect_to :root
    end
  end

  # GET /integrations/new
  def new
    @integration = Integration.new
    @agents = current_user.agents
    @templates = current_user.templates

    @agent = Agent.new
    @template = Template.new
  end

  # GET /integrations/1/edit
  def edit
    @agents = current_user.agents
    @templates = current_user.templates
  end

  # POST /integrations
  # POST /integrations.json
  def create
    @integration = Integration.new(integration_params)
    @integration.status = 200

    respond_to do |format|
      if @integration.save
        current_user.integrations.push(@integration)
        current_user.save
        #format.html { redirect_to @integration, notice: 'Integration was successfully created.' }
        format.json { render json: @integration, status: :created }#, location: @integration }
      else
        format.html { render action: 'new' }
        format.json { render json: @integration.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /integrations/1
  # PATCH/PUT /integrations/1.json
  def update
    respond_to do |format|
      if @integration.update(integration_params)
        format.html { redirect_to @integration, notice: 'Integration was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @integration.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /integrations/1
  # DELETE /integrations/1.json
  def destroy
    current_user.integrations.delete(@integration)
    @integration.destroy
    respond_to do |format|
      format.html { redirect_to integrations_url }
      format.json { head :no_content }
    end
  end

  ##
  # => AJAX updates to integrations (add/remove agents, add/remove templates)
  #
  def save
    begin
      @integration = Integration.find(params[:id])
      if (params[:remove]) then        
        unless params[:template].nil? then
          @integration.templates.destroy(Template.find(params[:template]))
        end

        unless params[:agent].nil? then
          @integration.agents.destroy(Agent.find(params[:agent]))
        end
      else
        unless params[:template].nil? then
          @integration.templates.push(Template.find(params[:template]))
        end

        unless params[:agent].nil? then
          @integration.agents.push(Agent.find(params[:agent]))
        end
      end

      @integration.status = 100
      @integration.save
    rescue Exception => e
      Services::Slog.exception e
    end

    respond_to do |format|
      format.json {render json: @integration}
      format.js {render json: @integration}
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_integration
    begin
      @integration = Integration.find(params[:id])
    rescue Exception => e
      Services::Slog.exception e
      flash[:notice] = "Sorry, <i class=\"icon-shuffle\"></i> couldn't find the integration identified by <em>#{params[:id]}</em>."
      redirect_to :controller => "templates", :action => "index"
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def integration_params
    params.require(:integration).permit(:identifier, :title, :help, :payload, :memory)
  end
end

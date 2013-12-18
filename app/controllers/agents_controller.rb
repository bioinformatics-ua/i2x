class AgentsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_agent, only: [:show, :edit, :update, :destroy]

  # GET /agents
  # GET /agents.json
  def index
    @agents = current_user.agents
    @events = Event.by_user_limit current_user
  end

  # GET /agents/1
  # GET /agents/1.json
  def show
    begin
      @agent = current_user.agents.find(params[:id])

    rescue Exception => e
      flash[:notice] = "You are not authorized to access that Agent"
      Services::Slog.exception e
      redirect_to :root
    end
  end

  # GET /agents/new
  def new
    @agent = Agent.new
    @seed = Seed.new
    @seed.publisher = 'none'

    respond_to do |format|
      format.html {render action: "new"}
      format.js { render layout: "application" }
    end
  end

  # GET /agents/1/edit
  def edit
  end

  # POST /agents
  # POST /agents.json
  def create
    @help = Services::Helper.new
    @agent = Agent.new agent_params
    @agent.last_check_at = @help.datetime
    @agent.status = 100
    @agent.events_count = 0

    # include seed in agent?
    if params[:seed][:publisher] != 'none' then
      @seed = @agent.seeds.build(seed_params)
    end

    respond_to do |format|
      if @agent.save
        current_user.agents.push(@agent)
        current_user.save
        #format.html { redirect_to @agent, notice: 'Agent was successfully created.' }
        #format.json { render action: json: @integration, status: :created#'show', status: :created, location: @agent }
        format.json { render json: @agent, status: :created }
      else
        format.html { render action: 'new' }
        format.json { render json: @agent.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /agents/1
  # PATCH/PUT /agents/1.json
  def update
    respond_to do |format|
          # include seed in agent?
          if params[:seed][:publisher] != 'none' then
            @seed.update(seed_params)
          end
          if @agent.update(agent_params)
            format.html { redirect_to @agent, notice: 'Agent was successfully updated.' }
            format.json { head :no_content }
          else
            format.html { render action: 'edit' }
            format.json { render json: @agent.errors, status: :unprocessable_entity }
          end
        end
      end

  # DELETE /agents/1
  # DELETE /agents/1.json
  def destroy
    @agent.destroy
    respond_to do |format|
      format.html { redirect_to agents_url }
      format.json { head :no_content }
    end
  end

  def import
    @file = File.read("data/agents/#{params[:identifier]}.js")
    puts @file
    @agent = Agent.create! JSON.parse(@file)
    response = { :status => 200, :message => "[i2x]: agent #{params[:identifier]} imported", :id => @agent[:id] }
    respond_to do |format|
      format.json { render :json => response}
      format.xml { render :xml => response}
    end
  end

  def partials
    render :partial => "publisher#{params[:identifier]}"
  end

  def get
    begin
     @agent = Agent.find(params[:identifier])
     respond_to do |format|
      format.json { render :json => @agent}
      format.xml { render :xml => @agent}
    end
  rescue Exception => e
    Services::Slog.exception e
  end
end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_agent
    begin
      @agent = Agent.find(params[:id])
    rescue Exception => e
      Services::Slog.exception e
      flash[:notice] = "Sorry, <i class=\"icon-shuffle\"></i> couldn't find the agent identified by <em>#{params[:id]}</em>."
      redirect_to :controller => "agents", :action => "index"
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def agent_params
    a = params[:agent].clone
    a[:agent] = params[:agent]
    a.require(:agent).permit(:publisher, :payload, :identifier, :title, :help, :schedule, :seed, :action, :uri, :cache, :headers, :delimiter, :checked ,:sqlserver, :host, :port, :database, :username, :password, :query, :selectors)

  end

  def seed_params
    s = params[:seed].clone
    s[:seed] = params[:seed]
    s.require(:seed).permit(:publisher, :payload, :identifier, :title, :help,:uri, :cache, :headers, :delimiter, :sqlserver, :host, :port, :database, :checked,:username, :password, :query, :selectors)
  end
end
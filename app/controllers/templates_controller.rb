class TemplatesController < ApplicationController
  before_action :set_template, only: [:show, :edit, :update, :destroy]

  # GET /templates
  # GET /templates.json
  def index
    @templates = Template.all
  end

  # GET /templates/1
  # GET /templates/1.json
  def show
  end

  # GET /templates/new
  def new

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

  # GET /templates/1/edit
  def edit
  end

  # POST /templates
  # POST /templates.json
  def create
    @template = Template.new(template_params)
    respond_to do |format|
      if @template.save
        format.html { redirect_to @template, notice: 'Template was successfully created.' }
        format.json { render action: 'show', status: :created, location: @template }
      else
        format.html { render action: 'new' }
        format.json { render json: @template.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /templates/1
  # PATCH/PUT /templates/1.json
  def update
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

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_template
    @template = Template.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def template_params
    params.require(:template).permit(:identifier, :title, :help, :publisher, :variables, :payload, :memory, :count, :last_execute_at, :created_at, :updated_at)
  end
end
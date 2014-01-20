class CachesController < ApplicationController
  before_action :set_cach, only: [:show, :edit, :update, :destroy]

  # GET /caches
  # GET /caches.json
  def index
    @caches = Cache.all
  end

  # GET /caches/1
  # GET /caches/1.json
  def show
  end

  # GET /caches/new
  def new
    @cach = Cache.new
  end

  # GET /caches/1/edit
  def edit
  end

  # POST /caches
  # POST /caches.json
  def create
    @cach = Cache.new(cach_params)

    respond_to do |format|
      if @cach.save
        format.html { redirect_to @cach, notice: 'Cache was successfully created.' }
        format.json { render action: 'show', status: :created, location: @cach }
      else
        format.html { render action: 'new' }
        format.json { render json: @cach.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /caches/1
  # PATCH/PUT /caches/1.json
  def update
    respond_to do |format|
      if @cach.update(cach_params)
        format.html { redirect_to @cach, notice: 'Cache was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @cach.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /caches/1
  # DELETE /caches/1.json
  def destroy
    @cach.destroy
    respond_to do |format|
      format.html { redirect_to caches_url }
      format.json { head :no_content }
    end
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_cach
    @cach = Cache.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def cach_params
    params.require(:cach).permit(:hash, :publisher, :agent, :payload, :memory)
  end
end
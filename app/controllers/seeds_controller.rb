class SeedsController < ApplicationController
  before_action :set_seed, only: [:show, :edit, :update, :destroy]

  # GET /seeds
  # GET /seeds.json
  def index
    @seeds = Seed.all
  end

  # GET /seeds/1
  # GET /seeds/1.json
  def show
  end

  # GET /seeds/new
  def new
    @seed = Seed.new
  end

  # GET /seeds/1/edit
  def edit
  end

  # POST /seeds
  # POST /seeds.json
  def create
    @seed = Seed.new(seed_params)

    respond_to do |format|
      if @seed.save
        format.html { redirect_to @seed, notice: 'Seed was successfully created.' }
        format.json { render action: 'show', status: :created, location: @seed }
      else
        format.html { render action: 'new' }
        format.json { render json: @seed.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /seeds/1
  # PATCH/PUT /seeds/1.json
  def update
    respond_to do |format|
      if @seed.update(seed_params)
        format.html { redirect_to @seed, notice: 'Seed was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @seed.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /seeds/1
  # DELETE /seeds/1.json
  def destroy
    @seed.destroy
    respond_to do |format|
      format.html { redirect_to seeds_url }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_seed
    @seed = Seed.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def seed_params
    params.require(:seed).permit(:identifier, :title, :publisher, :help, :payload, :memmory)
  end
end
class EventsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_event, only: [:show, :destroy]

  # GET /events
  # GET /events.json
  def index
    begin
      # use Kaminari for pagination      
      @events = Kaminari.paginate_array(Event.by_user(current_user)).page(params[:page])
      unless params[:page].nil? then
        @events.page params[:page]
      else
        params[:page] = 1
        @events.page 1
      end
    rescue Exception => e
      Services::Slog.exception e
    end
    
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:payload, :memory)
    end
  end

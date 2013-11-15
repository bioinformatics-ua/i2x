class PushController < ApplicationController
  def checkup
    begin
      @agent = Agent.find_by! identifier: params[:identifier]
      @agent.content = params.to_json
      Thread.new {@checkup = Services::Checkup.new.execute(@agent)}
      #@checkup = params[:payload]
      respond_to do |format|
        format.json { render json: @agent }
        format.js { render json: @agent }
      end
    rescue Exception => e
      Services::Slog.exception e
    end

  end
end
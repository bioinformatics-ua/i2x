class PushController < ApplicationController
  def checkup
    begin
      @agent = Agent.find_by! identifier: params[:identifier]
      @agent.content = params.to_json
      File.open("tmp/data/#{params[:identifier]}.js", 'w+') { |file| file.write("#{@agent.content}") }
      Thread.new {
        @checkup = @agent.execute
      }
      respond_to do |format|
        format.xml { render json: @agent }
        format.json { render json: @agent }
        format.js { render json: @agent }
      end
    rescue Exception => e
      Services::Slog.exception e
    end

  end
end
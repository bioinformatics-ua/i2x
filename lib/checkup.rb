require 'delayed_job'
require 'csv'
require 'detector'
require 'sqldetector'
require 'csvdetector'
require 'xmldetector'
require 'rest-client'
require 'slog'

module Services
  class Checkup

    def check schedule

      begin
    #    Slog.debug({:message => "Starting checkup", :module => "Checkup", :task => "check", :extra => {:schedule => schedule}})
      rescue Exception => e
        Slog.exception e
      end

      @agents = Agent.where( :schedule => schedule).where("last_check_at < CURRENT_TIMESTAMP - INTERVAL 2 MINUTE")
      @checkup = {}
      @agents.each do |agent|
        Slog.debug({:message => "Processing agent #{agent.identifier}", :module => "Checkup", :task => "agent", :extra => {:agent => agent.identifier, :publisher => agent.publisher}})

        case agent.publisher
        when 'sql'
          begin
            @d = Services::SQLDetector.new(agent.identifier)
            @checkup = @d.checkup
          rescue Exception => e
            Slog.exception e
            @response = {:status => 400, :error => e}
          end
        when 'csv'
          begin
            @d = Services::CSVDetector.new(agent.identifier)
            @checkup = @d.checkup
          rescue Exception => e
            Slog.exception e
            @response = {:status => 400, :error => e}
          end
        when 'xml'
          begin
            @d = Services::XMLDetector.new(agent.identifier)
            @checkup = @d.checkup
          rescue Exception => e
            Slog.exception e
            @response = {:status => 400, :error => e}
          end
        when 'json'
          @response = {:status => 404, :error => "[i2x][Checkup] JSON detection is not implemented"}

        end

        begin
          if @checkup[:status] == 100 then
            Slog.info({:message => "Starting integrations processing", :module => "Checkup", :task => "integrations", :extra => {:agent => agent.identifier, :payload => @checkup[:payload].size}})
            agent.process @checkup
          else
          end
        rescue Exception => e
          Slog.exception e
        end
      end
    end
    ##
    # => Set execution for delayed_job
    #
    #handle_asynchronously :check
  end
end
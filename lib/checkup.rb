
require 'delayed_job'
require 'csv'
require 'detector'
require 'sqldetector'
require 'csvdetector'
require 'xmldetector'
require 'jsondetector'
require 'rest-client'
require 'slog'

module Services
  class Checkup

    def check schedule

      @agents = Agent.where( :schedule => schedule).where("last_check_at < CURRENT_TIMESTAMP - INTERVAL 1 MINUTE")
      @checkup = {}
      @agents.each do |agent|
        Services::Slog.debug({:message => "Processing agent #{agent.identifier}", :module => "Checkup", :task => "agent", :extra => {:agent => agent.identifier, :publisher => agent.publisher}})

        case agent.publisher
        when 'sql'
          begin
            @d = Services::SQLDetector.new(agent.identifier)
          rescue Exception => e
            Services::Slog.exception e
            @response = {:status => 400, :error => e}
          end
        when 'csv'
          begin
            @d = Services::CSVDetector.new(agent.identifier)
          rescue Exception => e
            Services::Slog.exception e
            @response = {:status => 400, :error => e}
          end
        when 'xml'
          begin
            @d = Services::XMLDetector.new(agent.identifier)
          rescue Exception => e
            Services::Slog.exception e
            @response = {:status => 400, :error => e}
          end
        when 'json'
          begin
            @d = Services::JSONDetector.new(agent.identifier)
          rescue Exception => e
            Services::Slog.exception e
            @response = {:status => 400, :error => e}
          end
        end
       
        # Start checkup
        begin
          @checkup = @d.checkup  
        rescue Exception => e
          Services::Slog.exception e
        end
               
       # Start detection
        begin
          @d.objects.each do |object|
            puts "Initiating #{object[:identifier]} detection"
            @d.detect object
          end
        rescue Exception => e
          Services::Slog.exception e
        end

        begin
          if @checkup[:status] == 100 then
            Services::Slog.info({:message => "Starting integrations processing", :module => "Checkup", :task => "integrations", :extra => {:agent => agent.identifier, :payload => @checkup[:payload].size}})
            agent.process @checkup

          else
          end
        rescue Exception => e
          Services::Slog.exception e
        end
      end
    end
    ##
    # => Set execution for delayed_job
    #
    #handle_asynchronously :check
  end
end
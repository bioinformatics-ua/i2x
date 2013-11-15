
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

    ##
    # = Perform the actual check execution
    #
    # + *agent*: the agent to verify
    #
    def execute agent
      
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
        unless agent.content.nil? then
          @d.content = agent.content
        end

        @checkup = @d.checkup
      rescue Exception => e
        Services::Slog.exception e
      end

      # Start detection
      begin
        @d.objects.each do |object|
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
      response = {:status => @checkup[:status], :message => "[i2x][Checkup][execute] All OK."}
      
    end
    #handle_asynchronously :execute
    

    ##
    # = Initate real-time (poll) check
    #
    # + *schedule*: the scheduling being checked
    def check schedule

      @agents = Agent.where( :schedule => schedule).where("last_check_at < CURRENT_TIMESTAMP - INTERVAL 2 MINUTE")
      @checkup = {}
      @agents.each do |agent|
        begin
          self.execute agent
        rescue Exception => e
          Services::Slog.exception e
        end
      end
    end
    #handle_asynchronously :check
    ##
    # => Set execution for delayed_job
    #
    
  end
end
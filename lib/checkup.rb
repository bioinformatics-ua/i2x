require 'slog'

module Services
  class Checkup

    ##
    # = Perform the actual check execution
    #
    # + *agent*: the agent to verify
    #
    def execute agent
      begin
        @response = agent.execute
      rescue Exception => e
        Services::Slog.exception e
        @response = {:status => 400, :error => e}
      end       
    end
    

    ##
    # = Initiate real-time (poll) check
    #
    # + *schedule*: the scheduling being checked
    def check schedule
      @agents = Agent.where( :schedule => schedule).where("last_check_at < CURRENT_TIMESTAMP - INTERVAL 2 MINUTE")
      #@checkup = {}
      @agents.each do |agent|
        begin
          self.execute agent
        rescue Exception => e
          Services::Slog.exception e
        end
      end
    end
    
  end
end
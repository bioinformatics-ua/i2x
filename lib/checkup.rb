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
      Integration.all.each do |integration|
        @agents = integration.agents.where( :schedule => schedule).where("last_check_at < CURRENT_TIMESTAMP - INTERVAL 5 MINUTE")
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
end
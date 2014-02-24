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
    # = Real-time poll started on server boot.
    # 
    def boot
      Integration.all.each do |integration|
        integration.agents.each do |agent|
          begin
            self.execute agent
          rescue Exception => e
            Services::Slog.exception e
          end
        end
      end
    end

    ##
    # = Initiate real-time (poll) check
    #
    # + *schedule*: the scheduling being checked
    def check schedule
      query = (ActiveRecord::Base.connection.instance_of? ActiveRecord::ConnectionAdapters::MysqlAdapter) ? 'last_check_at < CURRENT_TIMESTAMP - INTERVAL 10 MINUTE' : "last_check_at < (now() - '10 minutes'::interval)"

      Integration.all.each do |integration|
        @agents = integration.agents.where( :schedule => schedule).where(query)
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
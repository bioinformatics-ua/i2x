require 'slog'

module Services
  class Cashier

    public

    ##
    # = Verify
    # => Verify if items have already been seen in the past (on the cache).
    #
    # == Params
    # - *memory*: the key identifier to be verified
    # - *payload*: the value for matching/verification
    # - *agent*: the agent performing the verification
    # - *seed*: seed data (if available)
    #
    def self.verify memory, agent, payload, seed
      ##
      # => Redis implementation, use cache.
      #
      begin

        # if Redis is enabled...
        if ENV["CACHE_REDIS"] then
          # give me some cache!
          @redis = Redis.new :host => ENV["CACHE_HOST"], :port => ENV["CACHE_PORT"]
        end
      rescue Exception => e
        Services::Slog.exception e
      end

      # the actual verification
      if ENV["CACHE_REDIS"] then
        # commented, do not log all cache verifications
        #Services::Slog.debug({:message => "Verifying cache", :module => "Cashier", :task => "cache", :extra => {:agent => agent[:identifier], :memory => memory, :payload => payload, :seed => seed}})
        begin
          if @redis.hexists("#{agent[:identifier]}:#{seed}", "#{memory}") then
            response = {:status => 200, :message => "[i2x][Cashier] Nothing to update"}
          else
            @redis.hset("#{agent[:identifier]}:#{seed}", "#{memory}", payload)
            response = {:status => 100, :message => "[i2x][Cashier] Memory recorded to cache"}
          end
        rescue Exception => e
          response = {:message => "[i2x][Cashier] unable to verify cache content, #{e}", :status => 301}
          Services::Slog.exception e
        end
      end

      ##
      # => SQL implementation, use internal database.
      #
      # => To Do: Recheck implementation.
      #
      if ENV["CACHE_INTERNAL"] then
        results = Cache.where memory: memory, agent_id: agent.id, seed: seed
        if results.size == 0 then
          begin
            @cached = Cache.new({:memory => memory, :agent_id => agent.id, :payload => payload, :seed => seed})
            @cached.save
            response = {:status => 100, :message => "[i2x][Cashier] Memory recorded to cache"}
          rescue Exception => e
            response = {:message => "[i2x][Cashier] unable to save new cache content, #{e}", :status => 300}
            Services::Slog.exception e
          end
        else
          response = {:status => 200, :message => "[i2x][Cashier] Nothing to update"}
        end

      end

      response
    end
  end
end
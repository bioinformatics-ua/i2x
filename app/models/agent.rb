class Agent < ActiveRecord::Base
  ##
  # => Store for saving Hashes in DB
  # => Accessors to make everything easy to access
  #
  store 	:payload, accessors: [:uri, :cache, :headers, :delimiter, :sqlserver, :host, :port, :database, :username, :password, :query, :selectors]
  store	:memory

  ##
  # => Use SeedMappings to connect Seeds
  #
  has_many	:seed_mapping
  has_many	:seed, :through => :seed_mapping

  ##
  # => Use  Agents Mappings to connect Agents
  #
  has_many	:agent_mapping
  has_many	:agent, :through => :agent_mapping
  
  public
  
  ##
  # => Add predetermined number of events.
  #
  def update_events_count n
    events_count = events_count + n
    save
  end
  
  ##
  # => Update time for last event check.
  #
  def update_check_at time
    begin
      last_check_at = time
      save
    rescue Exception => e
      Services::Slog.exception e
    end
    
  end
  
  ##
  # => Initiate agent processing to perform delivery
  #
  def process checkup
    ##
    # => Load seed.
    #
    begin
    rescue Exception => e
      Services::Slog.exception e
    end
    
    ## this should be simpler!!!
    begin
      puts identifier
      AgentMapping.where(:agent_id => id).each do |mapping|
        Integration.where(:id => mapping.integration_id).each do |integration|
          integration.template.each do |t|
            Services::Slog.debug({:message => "Sending #{identifier} for delivery by #{t.identifier}", :module => "Agent", :task => "process", :extra => {:agent => identifier, :template => t.identifier}})
            checkup[:payload].each do |payload|
              RestClient.post "#{Settings.app.host}postman/deliver/#{t.identifier}.js", payload
            end
          end
        end
      end
    rescue Exception => e
      Services::Slog.exception e
    end
    
  end
end
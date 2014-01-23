require 'detector'
require 'csvdetector'
require 'jsondetector'
require 'xmldetector'
require 'sqldetector'
require 'delayed_job'

class Agent < ActiveRecord::Base
  ##
  # => Store for saving Hashes in DB
  # => Accessors to make everything easy to access
  #
  store 	:payload, accessors: [:uri, :cache, :checked, :headers, :delimiter, :sqlserver, :host, :port, :database, :username, :password, :query, :selectors]
  store	  :memory
  attr_accessor :content

  ##
  # => Use SeedMappings to connect Seeds
  #
  has_many	:seed_mapping
  has_many	:seeds, :through => :seed_mapping

  ##
  # => Use  User Agents  to connect Users
  #
  has_many  :user_agents
  has_many  :users, :through => :user_agents
  
  ##
  # => Use AgentMappings to connect Agents
  #
  has_many  :agent_mapping
  has_many  :integrations, :through => :agent_mapping

  ##
  # => Events mapping
  #
  has_many :events
  
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
      self.last_check_at = time
      self.save
    rescue Exception => e
      Services::Slog.exception e
    end
  end
  
  ##
  # => Perform the actual agent monitoring tasks.
  #
  def execute
    @checkup = {}
    Services::Slog.debug({:message => "Processing agent #{identifier}", :module => "Checkup", :task => "agent", :extra => {:agent => identifier, :publisher => publisher}})

    case publisher
    when 'sql'
      begin
        @d = Services::SQLDetector.new(identifier)
      rescue Exception => e
        Services::Slog.exception e
        @response = {:status => 400, :error => e}
      end
    when 'csv'
      begin
        @d = Services::CSVDetector.new(identifier)
      rescue Exception => e
        Services::Slog.exception e
        @response = {:status => 400, :error => e}
      end
    when 'xml'
      begin
        @d = Services::XMLDetector.new(identifier)
      rescue Exception => e
        Services::Slog.exception e
        @response = {:status => 400, :error => e}
      end
    when 'json'
      begin
        @d = Services::JSONDetector.new(identifier)
      rescue Exception => e
        Services::Slog.exception e
        @response = {:status => 400, :error => e}
      end
    end


      # Start checkup
      begin
        unless content.nil? then
          @d.content = content
        end
        update_check_at Time.now
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
          Services::Slog.info({:message => "Starting integrations processing", :module => "Checkup", :task => "integrations", :extra => {:agent => identifier, :payload => @checkup[:payload].size}})
          process @checkup
        else
        end
      rescue Exception => e
        Services::Slog.exception e
      end
      response = {:status => @checkup[:status], :message => "[i2x][Checkup][execute] All OK."}     
    end
    handle_asynchronously :execute

  ##
  # => Finish agent processing to perform delivery
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

      AgentMapping.where(:agent_id => id).each do |mapping|
        Integration.where(:id => mapping.integration_id).each do |integration|
          integration.templates.each do |t|
            Services::Slog.debug({:message => "Sending #{identifier} for delivery by #{t.identifier}", :module => "Agent", :task => "process", :extra => {:agent => identifier, :template => t.identifier}})
            checkup[:payload].each do |payload|
              response = RestClient.post "#{ENV["APP_HOST"]}postman/deliver/#{t.identifier}.js", payload
              case response.code
              when 200
                @event = Event.new({:payload => payload, :status => 100, :agent => self})
                @event.save
              else
                Services::Slog.warn({:message => "Delivery failed for #{identifier} in #{t.identifier}", :module => "Agent", :task => "process", :extra => {:agent => identifier, :template => t.identifier}})
              end              
            end
          end
        end
      end
    rescue Exception => e
      Services::Slog.exception e
    end
    
  end
end
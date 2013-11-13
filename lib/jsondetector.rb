require 'helper'
require 'cashier'
require 'open-uri'
require 'raven'
require 'rails_config'
require 'slog'
require 'jsonpath'
require 'rest-client'
require 'csv'
require 'json'
require 'seedreader'
require 'csvseedreader'

module Services

  # = JSONDetector
  #
  # Detect changes in JSON content files (uses JSONPath).
  #
  class JSONDetector < Detector
    @payloads
    public

    ##
    # == Detect the changes
    #
    def detect object
      begin
        url = RestClient.get object[:uri]
        @doc = url.to_str
        Services::Slog.debug({:message => "Starting agent checkup #{@agent[:identifier]}", :module => "XMLDetector", :task => "checkup", :extra => {:agent => @agent[:identifier], :uri => @agent[:payload][:uri]}})
        JsonPath.on(@doc,object[:query]).each do |element|
          JsonPath.on(element, object[:cache]).each do |c|
            @cache = Cashier.verify c, object, c, object[:seed]
          end

          ##
          # If not on cache, add to payload for processing
          #
          if @cache[:status] == 100 then

            # add row data to payload from selectors (key => key, value => column name)
            payload = Hash.new
            JSON.parse(object[:selectors]).each do |selector|

              selector.each do |k,v|
                JsonPath.on(element, v).each do |el|
                  payload[k] = el
                end
              end
            end
            # add payload object to payloads list
            @payloads.push payload
          end
        end
        # url = RestClient.get @agent[:payload][:uri]
        # @doc = url.to_str
        # Services::Slog.debug({:message => "Starting agent checkup #{@agent[:identifier]}", :module => "XMLDetector", :task => "checkup", :extra => {:agent => @agent[:identifier], :uri => @agent[:payload][:uri]}})
        # JsonPath.on(@doc,agent[:payload][:query]).each do |element|
        #   JsonPath.on(element, @agent[:payload][:cache]).each do |c|
        #     @cache = Cashier.verify c, @agent, c, 'seed'
        #   end

        #   ##
        #   # If not on cache, add to payload for processing
        #   #
        #   if @cache[:status] == 100 then

        #     # add row data to payload from selectors (key => key, value => column name)
        #     payload = Hash.new
        #     JSON.parse(@agent[:payload][:selectors]).each do |selector|

        #       selector.each do |k,v|
        #         JsonPath.on(element, v).each do |el|
        #           payload[k] = el
        #         end
        #       end
        #     end
        #     # add payload object to payloads list
        #     @payloads.push payload
        #   end
        # end



      rescue Exception => e
        Services::Slog.exception e
      end

    end

    ##
    # == Start original source detection process
    #
    def checkup
      @payloads = Array.new
      @objects = Array.new
      @help = Services::Helper.new
      # update checkup time
      @agent.update_check_at @help.datetime

      begin
        @agent.seed.each do |seed|
          case seed[:payload][:publisher]
          when 'csv'
            begin
              @sr = Services::CSVSeedReader.new(@agent, seed)
              @reads = @sr.read
            rescue Exception => e
              Services::Slog.exception e
            end
          when 'sql'
            @sr = Services::SQLSeedReader.new(@agent, seed)
            @reads = @sr.read
          when 'xml'
            @sr = Services::XMLSeedReader.new(@agent, seed)
            @reads = @sr.read
          when 'json'
            @sr = Services::JSONSeedReader.new(@agent, seed)
            @reads = @sr.read
          end

          @reads.each do |read|
            @objects.push read
          end
        end

        @objects.each do |object|
          self.detect object
        end
      rescue Exception => e
        @response = {:status => 404, :message => "[i2x][JSONDetector] failed to load JSON doc, #{e}"}
        Services::Slog.exception e
      end

      begin
        # increase detected events count
        @agent.increment!(:events_count, @payloads.size)
        @response = { :payload => @payloads, :status => 100}
      rescue Exception => e
        @response = {:status => 404, :message => "[i2x][JSONDetector] failed to process JSONPath, #{e}"}
        Services::Slog.exception e
      end
      @response
    end
  end
end
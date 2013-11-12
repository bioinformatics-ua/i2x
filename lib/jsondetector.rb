require 'helper'
require 'cashier'
require 'open-uri'
require 'raven'
require 'rails_config'
require 'slog'
require 'jsonpath'
require 'rest-client'

module Services

  # = JSONDetector
  #
  # Detect changes in JSON content files (uses JSONPath).
  #
  class JSONDetector < Detector

    public

    def checkup
      @help = Services::Helper.new
      # update checkup time
      @agent.update_check_at @help.datetime

      
      begin
        url = RestClient.get @agent[:payload][:uri]
        @doc = url.to_str
        Services::Slog.debug({:message => "Starting agent checkup #{@agent[:identifier]}", :module => "XMLDetector", :task => "checkup", :extra => {:agent => @agent[:identifier], :uri => @agent[:payload][:uri]}})
      rescue Exception => e
        @response = {:status => 404, :message => "[i2x][XMLDetector] failed to load JSON doc, #{e}"}
        Services::Slog.exception e
      end

      begin
        @payloads = []
        JsonPath.on(@doc,agent[:payload][:query]).each do |element|
          JsonPath.on(element, @agent[:payload][:cache]).each do |c|
            
            @cache = Cashier.verify c, @agent, c
          end

          ##
          # If not on cache, add to payload for processing
          #
          if @cache[:status] == 100 then

            # add row data to payload from selectors (key => key, value => column name)
            payload = Hash.new
            JSON.parse(@agent[:payload][:selectors]).each do |selector|

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
      end
      # increase detected events count
      @agent.increment!(:events_count, @payloads.size)
      @response = { :payload => @payloads, :status => @cache[:status]}
    rescue Exception => e
      @response = {:status => 404, :message => "[i2x][XMLDetector] failed to process XPath, #{e}"}
      Services::Slog.exception e
    end
    @response
  end
end
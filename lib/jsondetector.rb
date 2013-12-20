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
require 'sqlseedreader'
require 'xmlseedreader'
require 'jsonseedreader'

module Services

  # = JSONDetector
  #
  # Detect changes in JSON content files (uses JSONPath).
  #
  class JSONDetector < Detector

    public

    ##
    # == Detect the changes
    #
    def detect object
      begin
        if object[:uri] == '' then
          @doc = object[:content]
        else
          url = RestClient.get object[:uri]
          @doc = url.to_str
        end
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
      rescue Exception => e
        Services::Slog.exception e
      end

    end
  end
end
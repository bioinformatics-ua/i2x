require 'helper'
require 'cashier'
require 'rdf'
require 'sparql'
require 'sparql/client'
require 'slog'

module Services

  ##
  # = SPARQLDetector
  #
  # Detect changes in SPARQL endpoints.
  #
  class SQLDetector < Detector

    public
    ##
    # == Detect the changes
    #
    def detect object
      begin
        @client = SPARQL::Client.new(object[:host])

        results = @client.query(@agent[:payload][:query])
        results.each do |row|
          unless object[:cache].nil? then
            @cache = Cashier.verify row[object[:cache]], object, row, object[:seed]
          else
            @cache = Cashier.verify row["id"], object, row, object[:seed]
          end

          # The actual processing
          #
          if @cache[:status] == 100 then

            # add row data to payload from selectors (key => key, value => column name)
            payload = Hash.new
            JSON.parse(object[:selectors]).each do |selector|
              selector.each do |k, v|
                payload[k] = row[v]
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

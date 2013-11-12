require 'helper'
require 'cashier'
require 'csv'
require 'open-uri'

module Services

  # = CSVDetector
  #
  # Detect changes in CSV files (using column numbers).
  #
  class CSVDetector < Detector

    public

    def checkup
      # update checkup time
      @agent.update_check_at @help.datetime
      
      @payloads = []
      @help = Services::Helper.new
      begin
        CSV.new(open(@agent[:payload][:uri]), :headers => :first_row).each do |row|
          unless @agent[:payload][:cache].nil? then
            @cache = Cashier.verify row[@agent[:payload][:cache]], @agent, row
          else
            @cache = Cashier.verify row[0], @agent, row
          end
          # The actual processing
          #
          if @cache[:status] == 100 then

            # add row data to payload from selectors (key => key, value => column name)
            payload = Hash.new
            JSON.parse(@agent[:payload][:selectors]).each do |selector|
              selector.each do |k,v|
                payload[k] = row[v]
              end
            end
            # add payload object to payloads list
            @payloads.push payload
          end
        end

        # increase detected events count
        @agent.increment!(:events_count, @payloads.size)
        @response = { :payload => @payloads, :status => 100}
      rescue Exception => e
        @response = {:status => 404, :message => "[i2x][CSVDetector] failed to load CSV doc, #{e}"}
        Services::Slog.exception e
      end

      @response
    end
  end
end
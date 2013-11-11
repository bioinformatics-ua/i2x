require 'helper'
require 'cashier'
require 'csv'
require 'open-uri'
require 'raven'

module Services

  # = CSVDetector
  #
  # Detect changes in CSV files (using column numbers).
  #
  class CSVDetector < Detector

    public

    def checkup
      @payloads = []
      @help = Services::Helper.new
      begin
        #@content
        #open(@agent[:payload][:uri]) {|f| @content = f.read()}
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
            # increase detected events count
            @agent.increment!(:events_count)

          end
        end



        @response = { :payload => @payloads, :status => 100}
      rescue Exception => e
        @response = {:status => 404, :message => "[i2x][CSVDetector] failed to load CSV doc, #{e}"}
        if Settings.log.sentry then
          Raven.capture_exception(e)
        end
      end

      begin
        @agent[:last_check_at] = @help.datetime
        @agent.save
      rescue Exception => e
        if Settings.log.sentry then
          Raven.capture_exception(e)
        end
      end

      @response
    end
  end
end
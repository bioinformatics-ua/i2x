require 'helper'
require 'cashier'
require 'open-uri'
require 'raven'
require 'rails_config'
require 'slog'

module Services

  # = XMLDetector
  #
  # Detect changes in XML files (uses XPath).
  #
  class XMLDetector < Detector

    public

    def checkup
      # update checkup time
      @agent.update_check_at @help.datetime
      
      @help = Services::Helper.new
      begin
        @doc = Nokogiri::XML(open(@agent[:payload][:uri]))
        Services::Slog.debug({:message => "Starting agent checkup #{@agent[:identifier]}", :module => "XMLDetector", :task => "checkup", :extra => {:agent => @agent[:identifier], :uri => @agent[:payload][:uri]}})

        
      rescue Exception => e
        @response = {:status => 404, :message => "[i2x][XMLDetector] failed to load XML doc, #{e}"}
        Services::Slog.exception e
      end

      begin
        @payloads = []
        @doc.remove_namespaces!
        @doc.xpath(@agent[:payload][:query]).each do |element|
          element.xpath(@agent[:payload][:cache]).each do |c|
            @cache = Cashier.verify c.content, @agent, c.content
          end

          ##
          # If not on cache, add to payload for processing
          #
          if @cache[:status] == 100 then
           
            # add row data to payload from selectors (key => key, value => column name)
            payload = Hash.new
            JSON.parse(@agent[:payload][:selectors]).each do |selector|

              selector.each do |k,v|
                element.xpath(v).each do |el|
                  payload[k] = el.content
                end
              end
            end
            # add payload object to payloads list
            @payloads.push payload           
            
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
end
require 'helper'
require 'cashier'
require 'open-uri'
require 'raven'
require 'rails_config'

module Services

  # = XMLDetector
  #
  # Detect changes in XML files (uses XPath).
  #
  class XMLDetector < Detector

    public

    def checkup
      @help = Services::Helper.new
      begin
        @doc = Nokogiri::XML(open(@agent[:payload][:uri]))
        if Settings.log.sentry then
        				Raven.capture_message("[i2x][XMLDetector] Starting agent checkup #{@agent[:identifier]}", { 
        					:level => 'info', 
        					:tags => {
         							'environment' => Rails.env,
         							'version' => Settings.app.version,
         							'module' => 'XMLDetector',
         							'task' => 'xml'
        						},
        						:server_name => Settings.app.host,
        					:extra => {
        						'agent' => @agent[:identifier]
        					}
        				})
        			end
      rescue Exception => e
        @response = {:status => 404, :message => "[i2x][XMLDetector] failed to load XML doc, #{e}"}
        puts "[i2x][XMLDetector] failed to load XML doc, #{e}"
        Raven.capture_exception(e)
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
                element.xpath(v).each do |e|
                  payload[k] = e.content
                end
              end
            end
            # add payload object to payloads list
            @payloads.push payload
            # increase detected events count
            @agent.increment!(:events_count)
          end
        end
        @response = { :payload => @payloads, :status => @cache[:status]}
      rescue Exception => e
        @response = {:status => 404, :message => "[i2x][XMLDetector] failed to process XPath, #{e}"}
        #puts "[i2x][XMLDetector] failed to process XPath, #{e}"
        Raven.capture_exception(e)
      end
      
      begin
	      @agent[:last_check_at] = @help.datetime
	      @agent.save
			rescue Exception => e
				Raven.capture_exception
			end
      

      @response
    end
  end
end
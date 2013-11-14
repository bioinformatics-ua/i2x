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
    ##
    # == Detect the changes
    #
    def detect object
      begin
        @doc = Nokogiri::XML(open(object[:uri]))
        @doc.remove_namespaces!
        @doc.xpath(object[:query]).each do |element|
          element.xpath(object[:cache]).each do |c|
            @cache = Cashier.verify c.content, object, c.content, object[:seed]
          end

          ##
          # If not on cache, add to payload for processing
          #
          if @cache[:status] == 100 then

            # add row data to payload from selectors (key => key, value => column name)
            payload = Hash.new
            JSON.parse(object[:selectors]).each do |selector|

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
      end
    rescue Exception => e
      Services::Slog.exception e
    end
  end
end
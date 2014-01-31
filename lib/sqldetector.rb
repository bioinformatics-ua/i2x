require 'helper'
require 'cashier'
require 'mysql2'
require 'slog'
require 'pg'

module Services

  ##
  # = SQLDetector
  #
  # Detect changes in SQL databases. MySQL support only.
  #
  class SQLDetector < Detector

    public
    ##
    # == Detect the changes
    #
    def detect object
      begin
        case object[:server]
          when 'mysql'
            @client = Mysql2::Client.new(:host => object[:host], :username => object[:username], :password => object[:password], :database => object[:database])
            @client.query(@agent[:payload][:query]).each(:symbolize_keys => false) do |row|
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
            @client.close
          when 'postgresql'
            client = PG::Connection.new(:host => object[:host], :user => object[:username], :password => object[:password], :dbname => object[:database])
            client.exec(object[:query]).each do |row|
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
        end
      rescue Exception => e
        Services::Slog.exception e
      end
    end
  end
end
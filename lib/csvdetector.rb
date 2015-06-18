require 'helper'
require 'cashier'
require 'csv'
require 'open-uri'
require 'seedreader'
require 'csvseedreader'
require 'sqlseedreader'
require 'xmlseedreader'
require 'jsonseedreader'
require 'libarchive'

module Services

  ##
  # = CSVDetector
  #
  # Detect changes in CSV files (using column numbers).
  #
  class CSVDetector < Detector

    public
    ##
    # == Detect the changes
    #
    def detect object
      begin

        ## check if file is zipped
        if object[:uri].to_s.end_with?('zip') || object[:uri].to_s.end_with?('gz')
          Archive.read_open_filename(object[:uri]) do |ar|
            while entry = ar.next_header
              name = entry.pathname
              data = ar.read_data

              CSV.new(data), :headers => :first_row).each do |row|
                unless object[:cache].nil?
                  @cache = Cashier.verify row[object[:cache].to_i], object, row, object[:seed]
                else
                  @cache = Cashier.verify row[0], object, row, object[:seed]
                end
                # The actual processing
                #
                if @cache[:status] == 100

                  # add row data to payload from selectors (key => key, value => column name)
                  payload = Hash.new
                  JSON.parse(object[:selectors]).each do |selector|
                    selector.each do |k, v|
                      payload[k] = row[v.to_i]
                    end
                  end
                  # add payload object to payloads list
                  @payloads.push payload
                end
              end
            end
          end
        else
          CSV.new(open(object[:uri]), :headers => :first_row).each do |row|
            unless object[:cache].nil?
              @cache = Cashier.verify row[object[:cache].to_i], object, row, object[:seed]
            else
              @cache = Cashier.verify row[0], object, row, object[:seed]
            end
            # The actual processing
            #
            if @cache[:status] == 100

              # add row data to payload from selectors (key => key, value => column name)
              payload = Hash.new
              JSON.parse(object[:selectors]).each do |selector|
                selector.each do |k, v|
                  payload[k] = row[v.to_i]
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

      @payloads
    end
  end
end

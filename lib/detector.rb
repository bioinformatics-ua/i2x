require 'slog'
require 'seedreader'
require 'csvseedreader'
require 'sqlseedreader'
require 'xmlseedreader'
require 'jsonseedreader'


module Services

  ##
  # = Detector
  #
  # Main change detection class, to be inherited by SQL, CSV, JSON and XML detectors (and others to come).
  #
  class Detector
    attr_accessor :identifier, :agent, :objects, :payloads, :content

    def initialize identifier
      begin
        @agent = Agent.find_by! identifier: identifier
        @payloads = Array.new
        @objects = Array.new
        @help = Services::Helper.new
      rescue Exception => e
        Services::Slog.exception e
      end
    end


    ##
    # == Start original source detection process
    #
    def checkup
      # update checkup time
      @agent.update_check_at @help.datetime

      begin

        ##
        # => Process seed data, if available.
        #
        if @agent.seed.size != 0 then
          @agent.seed.each do |seed|
            case seed[:publisher]
            when 'csv'
              begin
                @sr = Services::CSVSeedReader.new(@agent, seed)
              rescue Exception => e
                Services::Slog.exception e
              end
            when 'sql'
              begin
                @sr = Services::SQLSeedReader.new(@agent, seed)
              rescue Exception => e
                Services::Slog.exception e
              end
            when 'xml'
              begin
                @sr = Services::XMLSeedReader.new(@agent, seed)
              rescue Exception => e
                Services::Slog.exception e
              end
            when 'json'
              begin
                @sr = Services::JSONSeedReader.new(@agent, seed)
              rescue Exception => e
                Services::Slog.exception e
              end
            end
            begin
              @reads = @sr.read
              @reads.each do |read|
                @objects.push read
              end
            rescue Exception => e
              Services::Slog.exception e
            end
          end

        else
          ##
          # no seeds, simply copy agent data
          object = @help.deep_copy @agent[:payload]
          object[:identifier] = @agent[:identifier]
          object[:seed] = object[:identifier]
          unless self.content.nil? then
            object[:content] = self.content
          end
          @objects.push object
        end
      rescue Exception => e
        @response = {:status => 404, :message => "[i2x][JSONDetector] failed to load JSON doc, #{e}"}
        Services::Slog.exception e
      end

      begin
        # increase detected events count
        @agent.increment!(:events_count, @payloads.size)
        @response = { :payload => @payloads, :status => 100}
      rescue Exception => e
        @response = {:status => 404, :message => "[i2x][JSONDetector] failed to process JSONPath, #{e}"}
        Services::Slog.exception e
      end
      @response
    end
    

  end
end
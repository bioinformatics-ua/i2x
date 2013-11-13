require 'rails_config'
require 'slog'

module Services

  ##
  # = Helper Class
  # => Miscellaneous helper methods and utils to deal with data.
  #
  class Helper
    attr_accessor :replacements
    @replacements

    def initialize
      # load each helper function into a map for replacement in the delivery
      @replacements = [ ["%{i2x.date}", self.date], ["%{i2x.datetime}", self.datetime], ["%{i2x.hostname}", self.hostname]]
    end

    public
    def hostname
      Settings.app.host
    end

    def datetime
      Time.now.to_s
    end

    def date
      Time.now.strftime("%Y-%m-%d").to_s
    end

    ##
    # == Identify Variables
    # => Identifies variables on string set, generates array with all scanned variables for processing.
    # => Variables are enclosed in %{variable} string.
    #
    # * +text+ - string to be scanned
    #
    def identify_variables text
      begin
        results = Array.new
        text.scan(/%{(.*?)}/).each do |m|
          results.push m[0]
        end
      rescue Exception => e
        Services::Slog.exception e
      end

      results
    end

    ##
    # == Validate payload
    # => Validates content payload.
    #
    # + *publisher* - for publisher-specific validations
    # + *payload* - content for validation
    #
    def self.validate_payload publisher, payload
      @database_servers = ["mysql","sqlite","postgresql"]
      valid = true

      begin
        case publisher
        when 'csv', 'xml', 'json', 'file', 'js'
          # file content URI is mandatory
          if payload[:uri].nil? then
            valid = false
          end
        when 'sql'

          # check if database server is available
          unless database_servers.include? payload[:server] then
            valid = false
          end

          # database username is mandatory
          if payload[:username].nil? then
            valid = false
          end

          # database user password is mandatory
          if payload[:password].nil? then
            valid = false
          end

          # database name is mandatory
          if payload[:database].nil? then
            valid = false
          end

          # database query is mandatory
          if payload[:query].nil? then
            valid = false
          end
        end
      rescue Exception => e
        Services::Slog.exception e
      end
      valid
    end

    ##
    # == Validate Seed
    # => Validates Seed-specific properties
    #
    # + *publisher* - for publisher-specific validations
    # + *seed* - the seed hash
    #
    def self.validate_seed publisher, seed
      begin
        valid = self.validate_payload publisher, seed
        if valid then
          # seed must have selectors
          if seed[:selectors].nil? then
            valid = false
          end
        else
          valid = false
        end
      rescue Exception => e
        Services::Slog.exception e
      end

      valid
    end

    ##
    # == Validate Agent
    # => Validates Agent-specific properties
    #
    # + *agent* - the agent for validation
    #
    def self.validate_agent
      begin
        valid = self.validate_seed(agent[:publisher], agent[:payload]) && self.validate_payload(agent[:publisher], agent[:payload])
      rescue Exception => e
        Services::Slog.exception e
      end

      valid
    end

    ##
    # == Copy Object/Hash/Array...
    # => Copies any object into new object (overcome references).
    #
    # + *o* - the object being copied
    #
    def deep_copy object
      Marshal.load(Marshal.dump(object))
    end
  end
end
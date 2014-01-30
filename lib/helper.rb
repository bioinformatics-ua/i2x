require 'slog'
require 'securerandom'

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
      @replacements = [["${i2x.date}", self.date], ["${i2x.datetime}", self.datetime], ["${i2x.hostname}", self.hostname], ["${i2x.environment}",self.environment]]
    end

    public
    def random_hex
      SecureRandom.hex
    end

    def random_int
      SecureRandom.random_number(1000)
    end

    def random_string
      ([nil]*8).map { ((48..57).to_a+(65..90).to_a+(97..122).to_a).sample.chr }.join
    end

    def environment
      Rails.env.production? ? 'production' : 'development'
    end

    def hostname
      ENV["APP_HOST"]
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
    # == Process code.
    # => Evaluates Ruby code in template strings.
    # => Workflow: 1) look for 'i2x.code' strings, 2) evaluate matches, 3) replace code with evaluation results, 4) return processed string.
    #
    # @param text: the String for evaluation.
    #
    def process_code(text)
      begin
        results = text.clone
        # processing code function
        text.scan(/\${i2x.code\((.*?)\)}/).each { |k|
          k.each { |m|
            puts "\n\tProcessing: #{m}"
            results["${i2x.code(#{m})}"] = eval(m.to_s).to_s
          }
          } if text.include? 'i2x.code'
        rescue Exception => e
          Services::Slog.exception e
        end
        results
      end

    ##
    # == Process Functions
    # Identifies functions defined in predefined variables. Support: i2x.map.
    #
    def process_functions(text)
      begin
        results = Array.new
        # processing map function
        text.scan(/\${i2x.map\((.*?)\)}/).each { |m|
          puts m
          results.push m
          } if text.include? 'i2x.map'

        # processing compare function
        text.scan(/\${i2x.compare\((.*?)\)}/).each { |m|
          puts m
          results.push m
          } if text.include? 'i2x.compare'

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
      @database_servers = ["mysql", "sqlite", "postgresql"]
      valid = true

      begin
        case publisher
        when 'csv', 'xml', 'json', 'file', 'js', 'dropbox'
            # file content URI is mandatory
            valid = false if payload[:uri].nil?
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
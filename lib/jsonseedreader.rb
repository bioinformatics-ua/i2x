require 'slog'
require 'json'

module Services

  # = JSONSeedReader
  #
  # Load content from JSON seed.
  #
  class JSONSeedReader < SeedReader
    ##
    # == Read
    #
    # => Load the seed data into the @objects array for processing.
    #
    def read
      begin
        url = RestClient.get @seed[:payload][:uri]
        @doc = url.to_str
        JsonPath.on(@doc,@seed[:payload][:query]).each do |element|
          begin
            object = @help.deep_copy @agent[:payload]
            object.each_pair do |key,value|
              variables = @help.identify_variables(object[key])
              variables.each do |v|
                JsonPath.on(element, @seed[:payload][:selectors][v]).each do |el|
                  object[key].gsub!("%{#{v}}", el)
                end
              end
            end

            JsonPath.on(element,@seed[:payload][:cache]).each do |el|
            	object[:seed] = el
            end

            object[:identifier] = @agent.identifier
            @objects.push object
          rescue Exception => e
            Services::Slog.exception e
          end
        end
      rescue Exception => e
        Services::Slog.exception e
      end

      @objects
    end
  end
end
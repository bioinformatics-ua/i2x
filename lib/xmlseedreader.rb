require 'slog'

module Services

  # = XMLSeedReader
  #
  # Load content from XML seed.
  #
  class XMLSeedReader < SeedReader
    ##
    # == Read
    #
    # => Load the seed data into the @objects array for processing.
    #
    def read
      begin
        @doc = Nokogiri::XML(open(@seed[:payload][:uri]))
        @doc.remove_namespaces!
        @doc.xpath(@seed[:payload][:query]).each do |element|
          begin
            object = @help.deep_copy @agent[:payload]
            object.each_pair do |key,value|
              variables = @help.identify_variables(object[key])
              variables.each do |v|
                element.xpath(@seed[:payload][:selectors][v]).each do |el|
                  object[key].gsub!("%{#{v}}", el)
                end
              end
            end

            element.xpath(@seed[:payload][:cache]).each do |el|
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
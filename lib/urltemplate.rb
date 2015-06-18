require 'delivery'
require 'raven'
require 'rinruby'


module Services
  class URLTemplate < Delivery

    public

    ##
    # => Performs the actual delivery, in this case, execute URL request.
    #
    def execute

      case @template[:payload][:method]
      when 'get'
        begin
          out = RestClient.get @template[:payload][:uri]
          response = {:status => 200, :message => "[i2] GET request on #{@template[:payload][:uri]} executed.", :id => @template[:payload][:uri], :response => out.to_str}
        rescue Exception => e
          response = {:status => 400, :message => "Unable to perform GET request, #{e}"}
          Services::Slog.exception e
        end
      when 'post'
        begin

          case @template[:payload][:message]
          when 'form'
            out = RestClient.post @template[:payload][:uri], @template[:payload]
          when 'text/plain'
            out = RestClient.post @template[:payload][:uri], @template[:payload][:content], :content_type => 'text/plain'
          when 'application/javascript'
            if @template[:payload][:content].nil?
              out = RestClient.post @template[:payload][:uri], @template[:payload].to_json, :content_type => 'application/javascript'
            else
              out = RestClient.post @template[:payload][:uri], @template[:payload][:content], :content_type => 'application/javascript'
            end
          when "application/json"
            if @template[:payload][:content].nil?
              out = RestClient.post @template[:payload][:uri], @template[:payload].to_json, :content_type => 'application/json'
            else
              out = RestClient.post @template[:payload][:uri], @template[:payload][:content], :content_type => 'application/json'
            end
          when 'application/xml'
            if @template[:payload][:content].nil?
              out = RestClient.post @template[:payload][:uri], @template[:payload].to_xml, :content_type => 'application/xml'
            else
              out = RestClient.post @template[:payload][:uri], @template[:payload][:content], :content_type => 'application/xml'
            end
          when 'text/xml'
            if @template[:payload][:content].nil?
              out = RestClient.post @template[:payload][:uri], @template[:payload].to_xml, :content_type => 'text/xml'
            else
              out = RestClient.post @template[:payload][:uri], @template[:payload][:content], :content_type => 'text/xml'
            end
          when 'text/html'
            out = RestClient.post @template[:payload][:uri], @template[:payload][:content], :content_type => 'text/html'
          end

          response = {:status => 200, :message => "[i2] POST request on #{@template[:payload][:uri]} executed.", :id => @template[:payload][:uri], :response => out.to_str}
        rescue Exception => e
          response = {:status => 400, :message => "Unable to perform POST request, #{e}"}
        end
      when 'put'
        begin

        rescue Exception => e
          response = {:status => 440, :message => "Unable to perform PUT request (not implemented), #{e}"}
        end
      when 'delete'
        begin

        rescue Exception => e
          response = {:status => 440, :message => "Unable to perform DELETE request (not implemented), #{e}"}
        end
      end
      response
    end
    #handle_asynchronously :execute

    ##
    # => Validates the server connection properties
    #
    def validate_properties
      true
    end
  end

end

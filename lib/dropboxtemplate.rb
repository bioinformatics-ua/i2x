require 'delivery'
require 'slog'
require 'dropbox_sdk'
require 'rinruby'

module Services
  class DropboxTemplate < Delivery

    public

    ##
    # => Performs the actual delivery, in this case, create/update file on Dropbox.
    #
    def execute
      Services::Slog.debug({:message => "Dropbox update for #{@template[:identifier]}", :module => "FileTemplate", :task => "execute", :extra => {:template => @template[:identifier], :payload => @template[:payload]}})
      response = {}

      # Check if there are dropbox authorizations for user
      @template.users.each do |user|
        authorizations = user.authorizations.where(:provider => 'dropbox_oauth2')
        if authorizations.empty? then
          response = { :status => "404", :message => "No linked Dropbox account.", :id =>  @template[:payload][:uri]}
        else
          # Connect to Dropbox
          auth = authorizations.first
          client = DropboxClient.new(auth.token)
          case @template[:payload][:method]
          when 'create'
            begin
              if @template[:payload][:content].nil? then
                # Create empty file
                reply = client.put_file(@template[:payload][:uri], "\n", true)
              else
                # Create file with content
                reply = client.put_file(@template[:payload][:uri], @template[:payload][:content], true)
              end
              response = { :status => "200", :message => "File created on Dropbox account.", :id =>  @template[:payload][:uri], :reply => reply}
            rescue Exception => e
              Services::Slog.exception e
              response = { :status => "400", :message => "Unable to create file on Dropbox, #{e}"  }
            end
          when 'append'
            begin
              # Download existing file and copy to temp (if exists)
              begin
                contents, metadata = client.get_file_and_metadata(@template[:payload][:uri])
                File.open("tmp/i2x/#{@template[:payload][:uri]}", 'a+') {|f| f.puts contents }
              rescue Exception => e
                Services::Slog.exception e
              end
              # Append new content to file
              unless @template[:payload][:content].nil? then
                File.open("tmp/i2x/#{@template[:payload][:uri]}", "a+") { |file| file.write(@template[:payload][:content]) }
              end

            # Upload modified file to dropbox
            reply = client.put_file(@template[:payload][:uri], open("tmp/i2x/#{@template[:payload][:uri]}"), true)


            response = { :status => "200", :message => "File updated on Dropbox account.", :id =>  @template[:payload][:uri], :reply => reply}
          rescue Exception => e
            Services::Slog.exception e
            response = { :status => "400", :message => "Unable to update file on Dropbox, #{e}"  }
          end
        end
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
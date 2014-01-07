require 'delivery'
require 'slog'
require 'dropbox_sdk'
require 'mail'

module Services
  class MailTemplate < Delivery

    public

    ##
    # => Performs the actual delivery, in this case, send email.
    #
    def execute
      Services::Slog.debug({:message => "Sending email for #{@template[:identifier]}", :module => "MailTemplate", :task => "execute", :extra => {:template => @template[:identifier], :payload => @template[:payload]}})
      
      begin

      Mail.defaults do
       
      end

      mail = Mail.new
      mail.from = 'pedrolopes@ua.pt'
      mail.to = @template[:payload][:to]
      mail.subject = @template[:payload][:subject]
      mail.bcc = @template[:payload][:bcc]
      mail.cc = @template[:payload][:cc]
      mail.body = @template[:payload][:message]
      
      mail.deliver

    rescue Exception => e
      Services::Slog.exception e
      response = { :status => "400", :message => "Unable to send email, #{e}"  }
    end

    response = { :status => "200", :message => "Email sent to #{@template[:payload][:to]}", :id =>  @template[:identifier]}            
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
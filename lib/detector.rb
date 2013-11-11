require 'raven'

module Services

  ##
  # = Detector
  #
  # Main change detection class, to be inherited by SQL, CSV and XML detectors (and others to come).
  #
  class Detector
    attr_accessor :identifier, :publisher, :agent

    def initialize identifier
      begin
        @agent = Agent.find_by! identifier: identifier
      rescue Exception => e
        if Settings.log.sentry then
          Raven.capture_exception(e)
        end
      end
    end
  end
end
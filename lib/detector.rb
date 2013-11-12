require 'slog'

module Services

  ##
  # = Detector
  #
  # Main change detection class, to be inherited by SQL, CSV, JSON and XML detectors (and others to come).
  #
  class Detector
    attr_accessor :identifier, :agent

    def initialize identifier
      begin
        @agent = Agent.find_by! identifier: identifier
      rescue Exception => e
        Services::Slog.exception e
      end
    end
  end
end
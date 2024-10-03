module Loggable
  extend ActiveSupport::Concern

  attr_accessor :logger
  attr_reader :filename

  def logger
    @logger ||= begin
                  logger = Logger.new(log_filename)
                  logger.formatter = ->(severity, time, progname, message) do
                    "#{severity} -- #{progname}: #{message}\n"
                  end
                  logger
                end
  end

  def log
    File.read(log_filename)
  end

  private

  def log_filename
    @filename ||= "#{Time.now.xmlschema}_#{prog_name}##{object_id}.log"
    File.join(logs_path, filename)
  end

  def prog_name
    self.class
  end

  def logs_path
    self.class.send :logs_path
  end

  class_methods do
    def clear_logs
      FileUtils.rm_rf(File.join(logs_path, "."))
    end

    private

    def logs_path
      Rails.root.join "log/#{prog_name}"
    end

    def prog_name
      self
    end
  end
end

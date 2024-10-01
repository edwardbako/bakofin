module Loggable
  extend ActiveSupport::Concern

  attr_accessor :logger
  attr_reader :filename

  def logger
    @logger ||= Logger.new(log_filename)
  end

  def log
    File.read(log_filename)
  end

  private

  def log_filename
    @filename ||= "#{prog_name}##{object_id}-#{Time.now.xmlschema}.log"
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

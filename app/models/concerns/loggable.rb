module Loggable
  extend ActiveSupport::Concern

  attr_accessor :logger
  attr_reader :log_filename

  def initialize(attributes = {})
    super
    @logger = attributes[:logger] if attributes.present? and attributes[:logger].present?
  end

  # TODO: Make logger globaly defined. That is no need to pass it through.
  def logger
    @logger ||= begin
                  logger = Logger.new(full_filename)
                  # logger.formatter = ->(severity, time, progname, message) do
                  #   "#{severity} -- #{progname}: #{message}\n"
                  # end
                  # logger
                end
  end

  def log
    File.read(full_filename)
  end

  private

  def full_filename
    @log_filename ||= "#{Time.now.xmlschema}_#{prog_name}##{object_id}.log"
    File.join(logs_path, log_filename)
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
      path = Rails.root.join "log/#{prog_name}"
      FileUtils.mkdir_p(path) unless File.exist?(path)
      path
    end

    def prog_name
      self
    end
  end
end

# TODO: Implement ReportBuilder or just leave as is
module AccountHelper
  def format
    { format: "%u %n", thousands_separator: " " }
  end

  def splitter
    ("-" * 80).yellow
  end
end

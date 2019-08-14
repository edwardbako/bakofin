# require_relative '../strategy_tester'

desc 'Run Strategy Tester for.'
task :strategy_tester => :environment do
  puts "Starting rake task"
  ARGV.each { |a| task a.to_sym do ; end }

  t = StrategyTester.new symbol: ARGV[1], timeframe: ARGV[2].to_i, strategy_class: ARGV[3].constantize
  t.run
  t.report
end


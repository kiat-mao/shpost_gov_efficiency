# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
env :PATH, ENV['PATH']
env :GEM_PATH, ENV['GEM_PATH']

set :output, "log/cron_log.log"


every :day, at: '00:05am' do
  runner "Express.init_expresses_yesterday"
end

every :day, at: ['10:30am', '02:30pm'] do
  runner "Express.refresh_traces_yesterday"
end

every :day, at: '01:05am' do
  runner "Express.refresh_traces_last_week"
end
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

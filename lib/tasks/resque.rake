require 'resque/tasks'

namespace :resque do
  task :setup => [:environment] do
    require 'resque/scheduler'
  end

end

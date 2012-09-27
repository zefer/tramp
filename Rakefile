require_relative 'lib/tramp.rb'

task :default => :test

namespace :tramp do

  desc 'Notify users if they have new or lost followers.'
  task :notify do
    Tramp.instance.notify
  end

  desc 'Start a console'
  task :console do
    sh "bundle exec irb -r ./lib/tramp.rb"
  end

end

require 'singleton'
require 'pony'
require 'mongoid'
require 'twitter'
require_relative 'user'

class Tramp
  include Singleton

  def initialize
    Mongoid.logger.level = Logger::WARN
    Mongoid.load!('./mongoid.yml')

    Twitter.configure do |config|
      config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
    end
  end

  def notify
    # expects env var USERS in list format like: 'username1:user1@email.com,username2:user2@email.com'
    users = ENV['USERS'].split(',')
    users.each do |u|
      username, email = u.split(':')
      user = User.find_or_initialize_by(username: username)
      user.email = email
      user.notify_changes
    end
  end

end

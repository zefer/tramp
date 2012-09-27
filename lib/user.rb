class User
  include Mongoid::Document

  field :followers, type: Array, default: []
  field :username, type: String
  field :email, type: String

  def notify_changes
    # find out who has followed/unfollowed since the last check
    current_followers = Twitter.follower_ids(username).ids
    new = current_followers - followers
    lost = followers - current_followers

    send_notification(new, lost)

    # write the current followers to the db
    self.followers = current_followers.to_a
    save
  end

  private

    def send_notification(new=[], lost=[])
      # don't notify when there haven't been any changes
      if new.empty? && lost.empty?
        puts "no changes for #{username}"
        return
      end

      subject = "[#{username} followers] "
      body = ''

      unless lost.empty?
        subject << "#{lost.length} lost. "
        body    << "These dudes have escaped:\n"
        lost = ids_to_users(lost)
        lost[:deleted].times {|i| body << "- (deleted)\n"}
        lost[:usernames].each {|u| body << "- https://twitter.com/#{u}\n"}
      end

      unless new.empty?
        subject << "#{new.length} gained. "
        body    << "\nThese dudes have joined your party:\n"
        new = ids_to_users(new)
        new[:deleted].times {|i| body << "- (deleted)\n"}
        new[:usernames].each {|u| body << "- https://twitter.com/#{u}\n"}
      end

      puts "notifying #{username}: #{subject}"

      Pony.mail({
        subject: subject.strip,
        to: email,
        from: "Tramp <#{ENV['GMAIL_ADDRESS']}>",
        via: :smtp,
        via_options: {
          address: 'smtp.gmail.com',
          port: '587',
          enable_starttls_auto: true,
          user_name: ENV['GMAIL_ADDRESS'],
          password: ENV['GMAIL_PASSWORD'],
          authentication: :plain,
          domain: "localhost.localdomain"
        },
        body: body.strip
      })
    end

    # get usernames for an array of ids, & a count of those that may have been deleted
    def ids_to_users(ids)
      users = { usernames: [], deleted: 0 }
      # API only allows you to query up to 100 users at a time
      ids.each_slice(100) do |some_ids|
        Twitter.users(*some_ids).each {|u| users[:usernames] << u.screen_name}
      end
      users[:deleted] = ids.length - users[:usernames].length

      users
    end

end

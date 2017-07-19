# Trampled

A simple app that sends email notifications when user(s) loose or gain Twitter followers.

## Usage

Run `rake tramp:notify` as a regular cron job, e.g. hourly follower checks.

## Setup

Requires a mongodb instance, and the following environment variables:

* `USERS` A list of users to be checked, and the email address to notify when that users' followers change. E.g. `USERS=bananaman:eric@banana.man,dude:dude@dudes.com`
* `RACK_ENV` Used by Mongoid to determine which connection (from mongoid.yml) to use. Even though this isn't a Rack app
* `EMAIL_FROM` From field for outgoing emails, e.g. `joe@zefer.co.uk` or `Tramp <tramp@zefer.co.uk>`
* `SMTP_HOST` Emails are sent via SMTP. You could use your Gmail account, or a service like SendGrid
* `SMTP_USERNAME`
* `SMTP_PASSWORD`
* `MONGODB_URL` When `RACK_ENV=production`, otherwise, localhost is used (see mongoid.yml)

## Simple deployment

This can easily be deployed to heroku, and run without cost using the Heroku Scheduler addon and a free MongoHQ instance.

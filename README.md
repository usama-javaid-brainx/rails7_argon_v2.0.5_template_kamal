# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies
  Yarn install

* Database creation

* Configuration
  gem install foreman
  bin/dev

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions
  Create .env file
  Add these 2 keys to it, You need to replace these keys with actual ones
  
  KAMAL_REGISTRY_PASSWORD=change-this
  RAILS_MASTER_KEY=another-env
* ...

#How to Start the project : today's date: 15/11/2023

 install ruby version to ruby 3.2.2
 * rvm install ruby-3.2.2

 install the gems
 * bundle install

 update the yarn version using
 * nvm install 14.14.0
 *  nvm use 14.14.0
 * yarn install

 create the database
 *  rails db:create
 * rails db:migrate

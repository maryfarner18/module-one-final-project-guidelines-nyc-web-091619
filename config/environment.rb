require 'bundler'
require "sinatra/activerecord"
require 'pry'
require "tty-prompt"
require 'csv'
require 'date'
require_relative "../app/helpers.rb"
require_relative "../app/start.rb"
require_relative "../app/exit.rb"
require_relative "../app/signup.rb"
require_relative "../app/models/dog.rb"
require_relative "../app/models/owner.rb"
require_relative "../app/models/walk.rb"
require_relative "../app/models/walker.rb"
require_relative "../app/models/user.rb"



Bundler.require


ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')

old_logger = ActiveRecord::Base.logger
ActiveRecord::Base.logger = nil



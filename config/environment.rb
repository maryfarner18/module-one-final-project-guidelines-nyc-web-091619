require 'bundler'
require "sinatra/activerecord"
require 'pry'

Bundler.require


ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')

require_all 'lib'

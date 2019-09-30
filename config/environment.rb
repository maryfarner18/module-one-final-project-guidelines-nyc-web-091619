require 'bundler'
require "sinatra/activerecord"
require 'pry'
require "tty-prompt"
require 'csv'

Bundler.require

prompt = TTY::Prompt.new
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')

require_all 'lib'

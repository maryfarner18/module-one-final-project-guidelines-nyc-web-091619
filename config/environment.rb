require 'bundler'
require "sinatra/activerecord"
require 'pry'
require "tty-prompt"
require 'csv'
require_relative "../app/models/Dog.rb"
require_relative "../app/models/Owner.rb"
require_relative "../app/models/Walk.rb"
require_relative "../app/models/Walker.rb"

Bundler.require

prompt = TTY::Prompt.new
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')




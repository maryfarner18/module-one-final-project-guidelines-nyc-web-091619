require_relative '../config/environment'

prompt= TTY::Prompt.new

puts "Welcome to Obe's World"

owner = Owner.find(1)
dog = Dog.find(1)
walker = Walker.find(1)
walk = Walk.find(1)

startup

binding.pry


#----------------------------WALKER ACTIONS--------------------------------------#

#-----------------------------------------------------------------------------------#

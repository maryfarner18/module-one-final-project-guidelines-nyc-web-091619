require_relative '../config/environment'

prompt= TTY::Prompt.new

owner = Owner.find(1)
dog = Dog.find(1)
walker = Walker.find(1)
walk = Walk.find(1)

# animation
startup


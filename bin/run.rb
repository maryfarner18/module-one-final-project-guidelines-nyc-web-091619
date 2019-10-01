require_relative '../config/environment'

puts "Hi"

owner = Owner.find(1)
dog = Dog.find(1)
walker = Walker.find(1)

binding.pry
puts "Bye"
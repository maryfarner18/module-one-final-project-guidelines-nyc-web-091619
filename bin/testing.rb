require_relative '../config/environment'

walk_array = [Walk.find(1), Walk.find(5), Walk.find(16), Walk.find(12)]
binding.pry
walk_array.sort_by! {|walk| walk.date_and_time}

binding.pry



puts "Bye bye!"

require_relative '../config/environment'

def string_to_datetime(date, time, ampm)
    date = date.split("-")
    time = time.split(":")
    hours = time[0].to_i
    if ampm == "PM" && hours != 12 
        hours += 12
    elsif ampm == "AM" && hours == 12
        hours = 0
    end
    date_and_time = Time.utc(date[0].to_i, date[1].to_i, date[2].to_i, hours, time[1].to_i)
end

#prints all the walks in walk_array like
#   #14: 30 minutes walk for Oberon on October 10, 2019
def pretty_walks(walk_array)
    walk_array.sort_by! {|walk| walk.date_and_time}
    walk_array.map do |walk| 
        month = walk.date_and_time.month
        day = walk.date_and_time.day
        year = walk.date_and_time.year
        "##{walk.id}: #{walk.length} minute walk for #{walk.dog.name} on #{Date::MONTHNAMES[month]} #{day}, #{year}"
    end
end

#prints just the dogs' names
def pretty_dogs(dogs)
    dogs.map {|dog| dog.name}
end

def reload_all
    Walk.all.each{|walk| walk.reload}
    Walker.all.each{|walker| walker.reload}
    Owner.all.each{|owner| owner.reload}
    Dog.all.each{|dog| dog.reload}
end



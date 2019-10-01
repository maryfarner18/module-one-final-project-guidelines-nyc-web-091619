require_relative '../config/environment'

prompt = TTY::Prompt.new
puts "Welcome to Obe's World"

owner = Owner.find(1)
dog = Dog.find(1)
walker = Walker.find(1)
walk = Walk.find(1)

user_type = prompt.select("Are you a owner or a walker?", %w(Owner Walker WoofImmaDog))

#[STRETCH] Login 
    # Login (determine owner/walker)
    # Sign Up

#----------------------------OWNER ACTIONS--------------------------------------#
if user_type == "Owner"
    
    #[STRETCH] Give option to create new owner (user)
    #identify which owner you are 
    id = prompt.ask('What is your user ID number?') {|q| q.validate /\d/, 'ID must be a round number!'}
    owner = Owner.find(id)
    puts "Welcome, #{owner.name}!"

    #THIS IS PROBABLY THE START OF A LOOP (till they choose exit
    options = ["See my dogs", "Request a walk", "Rate a walk", "Cancel a walk", "See Upcoming Walks", "Exit"]
    action = prompt.select("What would you like to do?", options)

    case action
    when options[0] #see dogs
        puts owner.pretty_dogs.join("\n")

    when options[1] #request walk
        doggo = prompt.select('Which of your dogs needs a walk?', owner.pretty_dogs)
        date = prompt.ask("What date? (YYYY-MM-DD)"){|q| q.validate /\d{4}-[0-1][0-2]-[0-3][0-9]\z/, 'Please enter a valid date'}
        time = prompt.ask("What time? (HH:MM)"){|q| q.validate /[01][0-9]:[0-5][0-9]\z/, 'Please enter a valid time'}
        ampm = prompt.select('AM or PM?', %w(AM PM))
        length = prompt.select('How long of a walk (in minutes)?', [30, 60])
        date_and_time = string_to_datetime(date, time, ampm)

        owner.request_walk(owner.dogs.find_by_name(doggo), date_and_time, length )
        puts "Great, your walk for #{doggo} is scheduled for #{date} at #{time} with #{walk.walker.name}!"
    when options[2] #rate walk

    when options[3] #cancel walk

    when options[4] #see upcoming

    when options[5] #exit
        ex = true
    end

end
#-------------------------------------------------------------------------------#




#----------------------------WALKER ACTIONS--------------------------------------#
if(user_type == "Walker")




end
#-------------------------------------------------------------------------------#

binding.pry

puts "Bye Bye"
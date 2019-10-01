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

#----------------------------OWNER ACTIONS--------------------------------------------------#
if user_type == "Owner"
    
    #[STRETCH] Give option to create new owner (user)
    #identify which owner you are 
    id = prompt.ask('What is your user ID number?') {|q| q.validate /\d/, 'ID must be a round number!'}
    owner = Owner.find(id)
    puts "Welcome, #{owner.name}!"

    ####LOOP TILL THEY CHOOSE TO EXIT! ##############
    ex = false
    while !ex do 
        options = ["See my dogs", "Request a walk", "Rate a walk", "Cancel a walk", "See walks currently in progress", "See Upcoming Walks", "See past walks", "Exit"]
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
            puts "Great, your walk for #{doggo} is scheduled for e#{date} at #{time} with #{walk.walker.name}!"

        when options[2] #rate walk
            response = prompt.select('Which walk would you like to rate?', owner.pretty_walks(owner.past_walks))
            rate_walk_id = response.split(/[#:]/)[1].to_i
            rate_walk = Walk.find(rate_walk_id)
            this_rating = prompt.ask("Great, what would you like to rate this walk? (1-5)"){|q| q.validate /[1-5].?[0-9]?[0-9]?\z/, 'Please enter a valid rating between 1 and 5'}
            rate_walk.update(rating: this_rating)
        
        when options[3] #cancel walk
            walk_to_cancel = prompt.select("Which of the walks you want to cancel?", owner.pretty_walks(owner.upcoming_walks))
            if walk_to_cancel
                id = walk_to_cancel.split(/[#:]/)[1].to_i
                owner.cancel_walk(Walk.find(id))
                puts "Great, your walk for #{Walk.find(id).dog.name} was cancelled!"
            else
                puts "Sorry, you don’t have any upcoming walks!!!"
            end

        when options[4] #see in progress
            puts owner.pretty_walks(owner.walks_in_progress).split("\n")

        when options[5] #see upcoming
            puts owner.pretty_walks(owner.upcoming_walks).split("\n")

        when options[6] #see past
            puts owner.pretty_walks(owner.past_walks).split("\n")

        when options[7] #exit
            system "clear"
            puts "Woof woof! Goodbye!"
            ex = true
            
        end

        if !ex
            prompt.ask("Hit enter when done")
            system "clear"
        end
    end

end
#-------------------------------------------------------------------------------#




#----------------------------WALKER ACTIONS--------------------------------------#
if(user_type == "Walker")

    #[STRETCH] Give option to create new owner (user)
    #identify which owner you are 
    id = prompt.ask('What is your user ID number?') {|q| q.validate /\d/, 'ID must be a round number!'}
    walker = Walker.find(id)
    puts "Welcome, #{walker.name}!"

    ex = false
    while !ex do 

        options = ["See current walk", "Start a Walk", "End a Walk", "Cancel A Walk", "See Upcoming Walks", "Exit"]
        action = prompt.select("What would you like to do?", options)
        
        case action
        when options[0] #current walk
        when options[1] #start walk
        when options[2] #end walk
        when options[3] #cancel walk
        when options[4] #upcoming walks
        when options[5] #exit
        end

    end

end
#-------------------------------------------------------------------------------#

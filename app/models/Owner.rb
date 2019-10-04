require_relative '../../config/environment'

class Owner < ActiveRecord::Base
    has_many :dogs
    has_one :user

    def add_dogs #Adds dogs to an Owner
        
        prompt= TTY::Prompt.new
        puts "Add a Dog:\n"

        #Loop until user says no more dogs to add
        loop do  
            dog_name = prompt.ask("Please enter your dog's name:")
            breed = prompt.ask("Please enter your dog's breed:")
            age = prompt.slider("Please enter your dog's age:", max:25, step: 0.5, default: 5, format: "|:slider| %.1f")
            gender = prompt.select("Is it a male or female?", %w(Male Female))
            notes = prompt.ask("Please enter anything we should know about your doggo:")

            doggo = Dog.create(name: dog_name, breed: breed, age: age, gender: gender, notes: notes, owner_id: self.id)
            puts "#{doggo.name} had been added!"

            more = prompt.select("Do you have more dogs to add?", %w(Yes No))
            if more == "No"
                break
            end
        end
    end #END ADD_DOGS


    def request_walk #Request a new walk at a given time and date for some dog
        
        prompt= TTY::Prompt.new

        dog_name = prompt.select('Which of your dogs needs a walk?', pretty_dogs(self.dogs) << "Go Back", per_page: 10)
        
        #Exit out if user changes their mind
        if dog_name == "Go Back"
            return false
        end
    
        #Get this dog, and create the walk 
        dog = self.dogs.find_by(name: dog_name)
        date = prompt.ask("What date? (YYYY-MM-DD)"){|q| q.validate /\d{4}-[0-1][0-2]-[0-3][0-9]\z/, 'Please enter a valid date'}
        time = prompt.ask("What time? (HH:MM)"){|q| q.validate /[01][0-9]:[0-5][0-9]\z/, 'Please enter a valid time'}
        ampm = prompt.select('AM or PM?', %w(AM PM))
        length = prompt.select('How long of a walk (in minutes)?', [30, 60])
        date_and_time = string_to_datetime(date, time, ampm)
    
        new_walk = Walk.create(dog_id: dog.id, date_and_time: date_and_time, length: length, status: "Requested")
        new_walk.assign_walker

        message = "\t\tGreat, your walk for #{dog_name} is scheduled for #{date} at #{time} with #{new_walk.walker.name}!"
        animation('happy_dog', 5, 10, 0.04, 10, message)

        new_walk
    end

     #List all of an owner's dogs
    def see_my_dogs
        # animation('doggo', 1, 1, 0.02, 10,"")
        puts "Your doggos:\n"
        puts pretty_dogs(self.dogs).join("\n")
    end

    ## UPDATING WALKS -------------------------------

    #Rates a given walk && calls on the method to update the walker's rating
    def rate_walk
        prompt= TTY::Prompt.new

        #Get list of past walks 
        past = self.past_walks 

        if past != "No past walks!"
            
            response = prompt.select('Which walk would you like to rate?', past << "Go Back", per_page: 10)
            if response == "Go Back"
                return false
            end

            #find the walk and update it
            walk_id = response.split(/[#:]/)[1].to_i
            walk = Walk.find(walk_id)
            rating = prompt.ask("Great, what would you like to rate this walk? (1-5)"){|q| q.validate /[1-5].?[0-9]?[0-9]?\z/, 'Please enter a valid rating between 1 and 5'}
            walk.update(rating: rating)

            #play "rate sound"
            `afplay ./app/audio/rate.mp3`
            puts "Your walk has been rated!"

            #update the walker's rating
            Walker.find(walk.walker_id).update_avg_rating(rating)
            
            return true #Success
        
        #Else if there are no past walks, return!
        else
            puts "Sorry, you have no past walks to rate!"
            prompt.ask("Hit enter when done")
            return false
        end
    end

    #Cancels an upcoming walk
    def cancel_walk
        
        prompt= TTY::Prompt.new

        #Find upcoming walks and list as options to cancel
        upcoming = self.upcoming_walks
        if upcoming != "No upcoming walks!"

            walk_to_cancel = prompt.select("Which of the walks you want to cancel?", upcoming << "Go Back", per_page: 10)
            
            #Exit if user changes their mind
            if walk_to_cancel == "Go Back"
                return false
            end

            #Find and cancel the walk
            id = walk_to_cancel.split(/[#:]/)[1].to_i
            Walk.find(id).update(status: "Cancelled")
            puts "Great, your walk for #{Walk.find(id).dog.name} was cancelled!"

            return true # Success

        #Else if there are not upcoming walks, exit
        else
            puts "Sorry, you don’t have any upcoming walks!!!"
            prompt.ask("Hit enter when done")
            return false
        end
    end

    ### GETTING WALK INFO ------------------------------------##

    # A generic "walk getter" that retrieves walks by status
    def walks(status)

        case status
        when "All" 
            self.dogs.map {|dog| dog.walks}.flatten

        when "Upcoming"
            walks("All").select do |walk| 
                walk.status == "Upcoming"
            end

        when "Past"
            walks("All").select do |walk|
                walk.status == "Complete"
            end 

        when "In Progress"
            walks("All").find do |walk|
                walk.status == "In Progress"
            end  

        end
    end

    # Prints the walks in progress
    def walks_in_progress
        in_prog = walks("In Progress")
        if( in_prog == nil)
            puts "No walks in progress!"
        else
            puts "In Progress Walks:"
            puts pretty_walks([in_prog]).split("\n")
        end
    end

    # Prints the upcoming walks
    def upcoming_walks
        upcoming = walks("Upcoming")
        if( upcoming == [])
            "No upcoming walks!"
        else
            pretty_walks(upcoming).split("\n")
        end
    end

    # Prints the past walks
    def past_walks
        past = walks("Past")
        if(past == [])
            "No past walks!"
        else
            pretty_walks(past).split("\n")
        end
    end

    # GET WALKER INFO -----------------------------------
    def my_walkers
        self.dogs.map{|doggo| doggo.walkers}.flatten.uniq
    end

end
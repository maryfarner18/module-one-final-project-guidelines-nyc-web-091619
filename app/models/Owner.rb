require_relative '../../config/environment'

class Owner < ActiveRecord::Base
    has_many :dogs
    has_one :user

    def add_dogs
        prompt= TTY::Prompt.new
        while prompt.select("Do you have a dog to add?", %w(Yes No)) == "Yes"
            dog_name = prompt.ask("Please enter your dog's name:")
            breed = prompt.ask("Please enter your dog's breed:")
            age = prompt.slider("Please enter your dog's age:", max:25, step: 0.5, default: 5, format: "|:slider| %.1f")
            gender = prompt.select("Is it a male or female?", %w(Male Female))
            notes = prompt.ask("Please enter anything we should know about your doggo:")

            doggo = Dog.create(name: dog_name, breed: breed, age: age, gender: gender, notes: notes, owner_id: self.id)
        end
    end


    def request_walk
        prompt= TTY::Prompt.new

        dog_name = prompt.select('Which of your dogs needs a walk?', pretty_dogs(self.dogs))
        dog = self.dogs.find_by(name: dog_name)
        date = prompt.ask("What date? (YYYY-MM-DD)"){|q| q.validate /\d{4}-[0-1][0-2]-[0-3][0-9]\z/, 'Please enter a valid date'}
        time = prompt.ask("What time? (HH:MM)"){|q| q.validate /[01][0-9]:[0-5][0-9]\z/, 'Please enter a valid time'}
        ampm = prompt.select('AM or PM?', %w(AM PM))
        length = prompt.select('How long of a walk (in minutes)?', [30, 60])
        date_and_time = string_to_datetime(date, time, ampm)
    
        new_walk = Walk.create(dog_id: dog.id, date_and_time: date_and_time, length: length, status: "Requested")
        new_walk.assign_walker

        message = "\t\tGreat, your walk for #{dog_name} is scheduled for #{date} at #{time} with #{new_walk.walker.name}!"
        animation('happy_dog', 5, 10, 0.02, 10, message)

        new_walk
    end

    def see_my_dogs
        animation('doggo', 1, 1, 0.02, 10,"")
        puts "Your doggos:\n"
        puts pretty_dogs(self.dogs).join("\n")
    end

    ## UPDATING WALKS -------------------------------
    def rate_walk
        prompt= TTY::Prompt.new
        past = self.past_walks 
        if past != "No past walks!"
            response = prompt.select('Which walk would you like to rate?', past)
            walk_id = response.split(/[#:]/)[1].to_i
            walk = Walk.find(walk_id)
            rating = prompt.ask("Great, what would you like to rate this walk? (1-5)"){|q| q.validate /[1-5].?[0-9]?[0-9]?\z/, 'Please enter a valid rating between 1 and 5'}
            walk.update(rating: rating)
            puts "Your walks has been rated!"
            
            old_rating =  walk.walker.average_rating
            if old_rating
                old_rating += rating.to_f
                old_rating /= 2.00
                old_rating = old_rating.round(2) 
                walk.walker.update(average_rating: old_rating)
            else
                walk.walker.update(average_rating: rating)
            end
            if walk.walker.average_rating < 3.0 
                User.destroy(walk.walker.user_id)
                Walker.destroy(walk.walker.id)
                puts "Uh Oh! Due to you low rating, #{walk.walker.name} has been fired!!!"
                animation('ashameddog', 1, 1, 0.05, 10, "")
            end
        else
            puts "Sorry, you have no past walks to rate!"
        end
    end

    def cancel_walk
        prompt= TTY::Prompt.new
        upcoming = self.upcoming_walks
        if upcoming != "No upcoming walks!"
            walk_to_cancel = prompt.select("Which of the walks you want to cancel?", upcoming)
            id = walk_to_cancel.split(/[#:]/)[1].to_i
            Walk.find(id).update(status: "Cancelled")
            puts "Great, your walk for #{Walk.find(id).dog.name} was cancelled!"
        else
            puts "Sorry, you don’t have any upcoming walks!!!"
        end
    end

    ### GETTING WALK INFO ------------------------------------##
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

    def walks_in_progress
        in_prog = walks("In Progress")
        if( in_prog == nil)
            puts "No walks in progress!"
        else
            puts "In Progress Walks:"
            puts pretty_walks([in_prog]).split("\n")
        end
    end

    def upcoming_walks
        upcoming = walks("Upcoming")
        if( upcoming == [])
            "No upcoming walks!"
        else
            pretty_walks(upcoming).split("\n")
        end
    end

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
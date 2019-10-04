require_relative '../../config/environment'

class Walker < ActiveRecord::Base
    has_many :dogs, through: :walks
    has_many :walks
    has_one :user

    # Cancels a given walk
    def cancel_walk
        prompt= TTY::Prompt.new

        # Find upcoming walks and give them as an option to cancel
        upcoming = self.upcoming_walks
        if upcoming != "No upcoming walks!"

            walk_to_cancel = prompt.select("Which of the walks you want to cancel?", upcoming << "Go Back")

            # Exit if walker changes their mind
            if walk_to_cancel == "Go Back"
                return false
            end

            # Find the walk and cancel it
            id = walk_to_cancel.split(/[#:]/)[1].to_i
            Walk.find(id).update(status: "Cancelled")
            puts "Great, your walk for #{Walk.find(id).dog.name} was cancelled!"

            return true # Success

        # Else if there are no upcoming walks, exit
        else
            puts "Sorry, you don’t have any upcoming walks!!!"
            prompt.ask("Hit enter when done")
            return false
        end
    end

    # Start a walk!
    def start_walk
        prompt= TTY::Prompt.new

        binding.pry
        # Make sure no walk is already in progress
        if self.current_walk != "No walk in progress!"
            puts "Sorry, you already have a walk in progress! Finish that one first!"
            prompt.ask("Hit enter when done")
            return false
        end

        # Find today's walks (the only ones that could be started) and select one
        upcoming = self.todays_walks
        if upcoming != "No upcoming walks!"
            walk_to_update = prompt.select("Which of the walks you want to start?", upcoming << "Go Back")

            # Exit if walker changes their mind
            if walk_to_update == "Go Back"
                return false
            end

            #Find the walk and update status to in progress
            id = walk_to_update.split(/[#:]/)[1].to_i
            Walk.find(id).update(status: "In Progress")
            message = "\t\t\t\tGreat, your walk with #{Walk.find(id).dog.name} has started!"
            animation('happy_dog', 2, 10, 0.05, 10, message)

            return true # Success

        # Else if there are no walks today, exit
        else
            puts "Sorry, you don’t have any scheduled walks!!!"
            prompt.ask("Hit enter when done")
            return false
        end
    end

    # Finish a walk
    def finish_walk
        prompt= TTY::Prompt.new

         # Find walks in progress (the only ones that could be ended) and select one
        current = self.current_walk
        if current != "No walk in progress!"
            walk = prompt.select("Which of the walks you want to finish?", current << "Go Back")

            # Exit if walker changes their mind
            if walk == "Go Back"
                return false
            end

            # Find the walk and update status to "Complete"
            id = walk.split(/[#:]/)[1].to_i
            Walk.find(id).update(status: "Complete")
            puts "Great, your walk with #{Walk.find(id).dog.name} has finished!"

            return true # Success

        # Else if there are no walks in progress, exit
        else
            puts "Sorry, you don’t have any active walks!!!"
            prompt.ask("Hit enter when done")
            return false
        end
    end

    # Gets today's walks & pretty prints
    def todays_walks
        upcoming = self.walks.select{|walk| walk.status == "Upcoming" && walk.date_and_time < Time.now.utc + 86400}
        if( upcoming == nil)
            "No upcoming walks!"
        else
            pretty_walks(upcoming).split("\n")
        end
    end

    # Gets upcoming walks
    def upcoming_walks
        upcoming = self.walks.select{|walk| walk.status == "Upcoming"}
        if( upcoming == [])
            "No upcoming walks!"
        else
            pretty_walks(upcoming).split("\n")
        end
    end

    # Gets past walks
    def past_walks
        past = self.walks.select{|walk| walk.status == "Complete"}
        if(past == [])
            "No past walks!"
        else
            pretty_walks(past).split("\n")
        end
    end

    # Gets the current walks (should be one only, so we use find)
    def current_walk
        current = self.walks.find do |walk|
            walk.status == "In Progress"
        end  
        if(current == nil)
            "No walk in progress!"
        else
            pretty_walks([current]).split("\n")
        end
        
    end

    # UNDER THE HOOD METHODS

    # Update the average rating with this new rating 
    # NOTE: this is called every time a walk is rated, so 
    # the average is always up to date... this is to avoid
    # having to calculate the average every time it's queried
    # as the DB gets large!
    def update_avg_rating(rating)

        # If the walker already had an average rating, calculate new avg with this rating
        old_rating =  self.average_rating
        if old_rating
            old_rating += rating.to_f
            old_rating /= 2.00
            old_rating = old_rating.round(2) 
            self.update(average_rating: old_rating)

        # If the walker hadn't been rated yet, set avg rating to this new rating
        else
            self.update(average_rating: rating)
        end

        # If a walker's rating drops below 3.0, fire them!
        if self.average_rating < 3.0 

            # Destroy all walks associated with this walker
            walker_id = self.id
            dest_walks = Walk.all.select {|walk| walk.walker_id == walker_id}
            dest_walks.each {|walk| Walk.destroy(walk.id)}

            # Destroy this walker and their user profile
            User.destroy(self.user_id)
            Walker.destroy(self.id)

            #Fun stuff
            animation('ashameddog', 1, 1, 0.05, 10, "")
            puts "Your walk has been rated!"
            #play "embarassing"
            `afplay ./app/audio/embarassing.m4a`
            puts "Uh Oh! Due to you low rating, #{self.name} has been fired!!!"
            #play "embarassing" again
            `afplay ./app/audio/embarassing.m4a`
        end
    end

    # Checks if a walker is free for a walk at the given time for a walk of the given length
    def is_free?(date_and_time, length)

        buffer = 1800 # 30 - minute buffer

        # Set this proposed walk's start and end time, including the buffer
        start_time = date_and_time - buffer
        end_time = date_and_time + (length * 60) + buffer

        # Go through all existing walks and make sure they don't overlap. If they do, return fale and exit
        walks.each do |walk|
                walk_start_time = walk.date_and_time 
                walk_end_time = walk.date_and_time + (walk.length * 60)
                if !((walk_start_time < start_time || walk_start_time > end_time) && (walk_end_time < start_time || walk_end_time > end_time))
                    return false
                end   
        end

        return true #They are free!

    end
end
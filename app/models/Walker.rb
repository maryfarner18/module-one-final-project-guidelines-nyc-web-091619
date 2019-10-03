require_relative '../../config/environment'

class Walker < ActiveRecord::Base
    has_many :dogs, through: :walks
    has_many :walks
    has_one :user

    #dogs
    #walks
    #avg_rating

    def cancel_walk
        prompt= TTY::Prompt.new
        upcoming = self.upcoming_walks

        if upcoming != "No upcoming walks!"
            walk_to_cancel = prompt.select("Which of the walks you want to cancel?", upcoming << "Go Back")
            if walk_to_cancel == "Go Back"
                return false
            end
            id = walk_to_cancel.split(/[#:]/)[1].to_i
            Walk.find(id).update(status: "Cancelled")
            puts "Great, your walk for #{Walk.find(id).dog.name} was cancelled!"
            return true
        else
            puts "Sorry, you don’t have any upcoming walks!!!"
            prompt.ask("Hit enter when done")
            return false
        end
    end

    def start_walk
        prompt= TTY::Prompt.new

        upcoming = self.todays_walks
        if upcoming != "No upcoming walks!"
            walk_to_update = prompt.select("Which of the walks you want to start?", upcoming << "Go Back")
            if walk_to_update == "Go Back"
                return false
            end
            id = walk_to_update.split(/[#:]/)[1].to_i
            Walk.find(id).update(status: "In Progress")
            message = "\t\t\t\tGreat, your walk with #{Walk.find(id).dog.name} has started!"
            animation('happy_dog', 2, 10, 0.05, 10, message)
            return true
        else
            puts "Sorry, you don’t have any scheduled walks!!!"
            prompt.ask("Hit enter when done")
            return false
        end
    end

    def update_avg_rating(rating)
        old_rating =  self.average_rating
        if old_rating
            old_rating += rating.to_f
            old_rating /= 2.00
            old_rating = old_rating.round(2) 
            self.update(average_rating: old_rating)
        else
            self.update(average_rating: rating)
        end
        if self.average_rating < 3.0 

            walker_id = self.id
            dest_walks = Walk.all.select {|walk| walk.walker_id == walker_id}
            dest_walks.each {|walk| Walk.destroy(walk.id)}

            User.destroy(self.user_id)
            Walker.destroy(self.id)
            animation('ashameddog', 1, 1, 0.05, 10, "")
            puts "Your walk has been rated!"
            #play "embarassing"
            `afplay ./app/audio/embarassing.m4a`
            puts "Uh Oh! Due to you low rating, #{self.name} has been fired!!!"
            #play "embarassing" again
            `afplay ./app/audio/embarassing.m4a`
        end
    end

    def finish_walk
        prompt= TTY::Prompt.new

        current = self.current_walk
        if current != "No walk in progress!"
            walk = prompt.select("Which of the walks you want to finish?", current << "Go Back")
            if walk == "Go Back"
                return false
            end
            id = walk.split(/[#:]/)[1].to_i
            Walk.find(id).update(status: "Complete")
            puts "Great, your walk with #{Walk.find(id).dog.name} has finished!"
            return true
        else
            puts "Sorry, you don’t have any active walks!!!"
            prompt.ask("Hit enter when done")
            return false
        end
    end

    def todays_walks
        upcoming = self.walks.select{|walk| walk.status == "Upcoming" && walk.date_and_time < Time.now.utc + 86400}
        if( upcoming == nil)
            "No upcoming walks!"
        else
            pretty_walks(upcoming).split("\n")
        end
    end

    def upcoming_walks
        upcoming = self.walks.select{|walk| walk.status == "Upcoming"}
        if( upcoming == [])
            "No upcoming walks!"
        else
            pretty_walks(upcoming).split("\n")
        end
    end

    def past_walks
        past = self.walks.select{|walk| walk.status == "Complete"}
        if(past == [])
            "No past walks!"
        else
            pretty_walks(past).split("\n")
        end
    end

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


    def is_free?(date_and_time, length)
        buffer = 1800
        start_time = date_and_time - buffer
        end_time = date_and_time + (length * 60) + buffer
        walks.each do |walk|
                walk_start_time = walk.date_and_time 
                walk_end_time = walk.date_and_time + (walk.length * 60)
                if !((walk_start_time < start_time || walk_start_time > end_time) && (walk_end_time < start_time || walk_end_time > end_time))
                    return false
                end   
        end
        return true
    end
end
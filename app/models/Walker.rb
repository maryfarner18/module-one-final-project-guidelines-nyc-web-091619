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
            walk_to_cancel = prompt.select("Which of the walks you want to cancel?", upcoming)
            id = walk_to_cancel.split(/[#:]/)[1].to_i
            Walk.find(id).update(status: "Cancelled")
            Walk.find(id).save
            Walker.reload
            puts "Great, your walk for #{Walk.find(id).dog.name} was cancelled!"
        else
            puts "Sorry, you don’t have any upcoming walks!!!"
        end
    end

    def start_walk
        prompt= TTY::Prompt.new
        upcoming = self.upcoming_walks
        if upcoming != "No upcoming walks!"
            walk_to_update = prompt.select("Which of the walks you want to start?", upcoming)
            id = walk_to_update.split(/[#:]/)[1].to_i
            Walk.find(id).update(status: "In Progress")
            message = "\t\t\t\tGreat, your walk with #{Walk.find(id).dog.name} has started!"
            animation('happy_dog', 5, 10, 0.02, 10, message)
        else
            puts "Sorry, you don’t have any scheduled walks!!!"
        end
    end

    def finish_walk
        prompt= TTY::Prompt.new
        current = self.current_walk
        if current != "No walk in progress!"
            walk = prompt.select("Which of the walks you want to finish?", current)
            id = walk.split(/[#:]/)[1].to_i
            Walk.find(id).update(status: "Complete")
            puts "Great, your walk with #{Walk.find(id).dog.name} has finished!"
            puts "Don't forget to fill up #{Walk.find(id).dog.name}'s waterbowl!'"
            `afplay ./app/audio/dog_drinking.mp3`
        else
            puts "Sorry, you don’t have any active walks!!!"
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
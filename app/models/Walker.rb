require_relative '../../config/environment'

class Walker < ActiveRecord::Base
    has_many :dogs, through: :walks
    has_many :walks
    has_one :user

    #dogs
    #walks
    #avg_rating

    def cancel_walk(walk)
        prompt= TTY::Prompt.new

        walk.update(status: "Cancelled") if walk.status != "Completed" && walk.status != "In Progress"
        #talk
    end

    def start_walk(walk)
        prompt= TTY::Prompt.new

        walk.update(status: "In Progress") if walk.status == "Upcoming"
        #talk
    end

    def finish_walk(walk)
        prompt= TTY::Prompt.new

        walk.update(status: "Complete") if walk.status == "In Progress"
        #talk
    end

    def upcoming_walks
        walks.select do |walk|
            walk.date_and_time > Time.now.utc
        end
        #talk

    end

    def past_walks
        walks.select do |walk|
            walk.date_and_time + (walk.length * 60) < Time.now.utc
        end 
        #talk  
    end

    def current_walk
        current = walks.find do |walk|
            walk.date_and_time <= Time.now.utc && walk.date_and_time + (walk.length * 60) >= Time.now.utc
        end  
        if(current == [])
            puts "No walks in progress!"
        else
            puts "In Progress Walks:"
            puts pretty_walks(current).split("\n")
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
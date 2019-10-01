class Walker < ActiveRecord::Base
    has_many :dogs, through: :walks
    has_many :walks

    #dogs
    #walks
    #avg_rating

    def cancel_walk(walk)
        walk.update(status: "Cancelled") if walk.status != "Completed" && walk.status != "In Progress"
    end

    def start_walk(walk)
        walk.update(status: "In Progress") if walk.status == "Upcoming"
    end

    def finish_walk(walk)
        walk.update(status: "Complete") if walk.status == "In Progress"
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
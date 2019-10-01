class Walk < ActiveRecord::Base
    belongs_to :dog
    belongs_to :walker

    def assign_walker
        while do
            id = rand(Walker.all.count) + 1
            #check if walker(id) is free at walk.date_and_time
        end
        
    end

    def start
    end

    def end_walk
    end
end

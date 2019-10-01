class Walk < ActiveRecord::Base
    belongs_to :dog
    belongs_to :walker

    #dog - returns the dog on this walk
    #walker - returns the walker on this walk

    #assigns a walker randomly to this walk
    def assign_walker
        assigned_walker = nil
        for i in Walker.all do 
            check_walker = Walker.all.sample
            binding.pry
            if check_walker.is_free?(date_and_time, length)
                assigned_walker = check_walker
                break
            end
        end
        if assigned_walker
            update(walker_id: assigned_walker.id)
            update(status: "Upcoming")
        else 
            puts "Sorry we couldn't find a walker!"
        end
        self
       
    end

    #makes sure that the walk isn't cancelled 
    def is_valid
        self.status != "Cancelled"
    end
end

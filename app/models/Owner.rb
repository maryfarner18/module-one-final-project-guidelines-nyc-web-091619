class Owner << ActiveRecord::Base
    has_many :dogs

    def upcoming_walks(dog)

    end

    def past_walks(dog)
        
    end

    def my_walkers

    end

end
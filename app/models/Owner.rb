class Owner < ActiveRecord::Base
    has_many :dogs

    def request_walk(dog, date_time, length)
        Walk.create(dog_id: dog.id, date_and_time: date_time, length: length, status: "Requested")
        #call some assign walker method
        
        # Time.new(YYYY, MM, DD, HH, MM, SS)
    end

    def rate_walk(walk, rating)
        walk.update(rating: rating)
    end

    def cancel_walk
    end

    def upcoming_walks(dog)

    end

    def past_walks(dog)
        
    end

    def my_walkers

    end

end
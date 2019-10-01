class Owner < ActiveRecord::Base
    has_many :dogs

    #returns an array of the owner's dogs' names
    def pretty_dogs
        dogs.map {|dog| dog.name}
    end

    def request_walk(dog, date_time, length)
        new_walk = Walk.create(dog_id: dog.id, date_and_time: date_time, length: length, status: "Requested")
        new_walk.assign_walker
        new_walk
    end

    ## UPDATING WALKS -------------------------------
    def rate_walk(walk, rating)
        walk.update(rating: rating)

        old_rating =  walk.walker.average_rating
        if old_rating
            old_rating += rating
            old_rating /= 2.00
            old_rating = old_rating.round(2) 
            walk.walker.update(average_rating: old_rating)
        else
            walk.walker.update(average_rating: rating)
        end
    end

    def cancel_walk(walk)
        walk.update(status: "Cancelled")
    end

    ### GETTING WALK INFO ------------------------------------###
    def pretty_walks(walk_array)
        walk_array.map do |walk| 
            month = walk.date_and_time.month
            day = walk.date_and_time.day
            year = walk.date_and_time.year
            # hours = walk.date_and_time.hour
            # minutes = walk.date_and_time.mins
            "##{walk.id}: #{walk.length} minute walk for #{walk.dog.name} on #{Date::MONTHNAMES[month]} #{day}, #{year}" #with #{walk.walker.name
        end
    end

    def walks 
        dogs.map {|dog| dog.walks}.flatten
    end

    def upcoming_walks
        walks.select do |walk|
            walk.date_and_time > Time.now.utc
        end
    end

    def past_walks
        walks.select do |walk|
            walk.date_and_time + (walk.length * 60) < Time.now.utc
        end   
    end

    def walks_in_progress
        walks.select do |walk|
            walk.date_and_time <= Time.now.utc && walk.date_and_time + (walk.length * 60) >= Time.now.utc
        end  
    end

    def my_walkers
        self.dogs.map{|doggo| doggo.walkers}.flatten.uniq
    end

end
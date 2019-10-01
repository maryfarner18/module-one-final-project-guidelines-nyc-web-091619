class Walker < ActiveRecord::Base
    has_many :dogs, through: :walks
    has_many :walks

    def cancel_walk(walk)
    end

    def start_walk(walk)
    end

    def finish_walk(walk)
    end

    def is_free?(date_and_time, length)
        # range = date_and_time + length
        # walks.each do |walk|
        #     walk.date_and_time + walk.length
        # end

    end
end
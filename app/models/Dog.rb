class Dog < ActiveRecord::Base
    belongs_to :owner
    has_many :walks
    has_many :walkers, through: :walks

    #owner
    #walkers
    #walks
    #find_by ()

    def upcoming_walks

    end

    def past_walks

    end
end
class Dog < ActiveRecord::Base
    belongs_to :owner
    has_many :walkers, through: :walks
    has_many :walks

    def upcoming_walks

    end

    def past_walks

    end
end
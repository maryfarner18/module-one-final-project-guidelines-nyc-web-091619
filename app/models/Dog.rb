require_relative '../../config/environment'

class Dog < ActiveRecord::Base
    belongs_to :owner
    has_many :walks
    has_many :walkers, through: :walks

end
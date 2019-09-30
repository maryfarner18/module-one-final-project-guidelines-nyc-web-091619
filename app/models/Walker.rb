class Walker << ActiveRecord::Base
    has_many :dogs, through: :walks
end
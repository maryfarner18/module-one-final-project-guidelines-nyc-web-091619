require_relative "../config/environment.rb"

dog_file = CSV.read('db/dog.csv', headers: true)
owner_file = CSV.read('db/owner.csv', headers: true)
walker_file = CSV.read('db/walker.csv', headers: true)
walk_file= CSV.read('db/walk.csv', headers: true)

# dog_file.each do |row|
#     Dog.create(name: row[0], breed: row[1], age: row[2], notes: row[3], owner_id: row[4], gender: row[5])
# end

# owner_file.each do |row|
#     Owner.create(name: row[0], address: row[1])
# end

# walk_file.each do |row|
#     Walk.create(dog_id: row[0], walker_id: row[1], date_and_time: row[2], length: row[3], status: row[4], rating: row[5])
# end

# walker_file.each do |row|
#     Walker.create(name: row[0], experience: row[1])
# end




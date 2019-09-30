require_relative "../config/environment.rb"

dog_file = CSV.read('db/dog.csv', headers: true)
owner_file = CSV.read('db/owner.csv', headers: true)
walker_file = CSV.read('db/walker.csv', headers: true)
walk_file= CSV.read('db/walk.csv', headers: true)

# dog_file.each do |row|
#     Dog.create(name: row[0], breed: row[1], age: row[2], notes: row[3], owner_id: row[4], gender: row[5])
# end

owner_file.each do |row|
    Owner.create(name: row[0], address: row[1])
end

walk_file.each do |row|
    DB.execute("INSERT INTO walk (dog_id, walker_id, date, time, length, status, rating) VALUES (?, ?, ?, ?, ?, ?, ?, ?)", row[0], row[1], row[2], row[3], row[4], row[5], row[6], row[7])
end

walker_file.each do |row|
    DB.execute("INSERT INTO walker (name, experience) VALUES (?, ?)", row[0], row[1])
end




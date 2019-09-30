dog_file = CSV.read('db/dog.csv', headers: true)
owner_file = CSV.read('db/owner.csv', headers: true)
# walker_file = CSV.read('db/walker.csv', headers: true)
# walk_file= CSV.read('db/walk.csv', headers: true)

dog_file.each do |row|
    DB.execute("INSERT INTO dogs (name, breed, age, notes, owner_id, gender) VALUES (?, ?, ?, ?, ?)", row[0], row[1], row[2], row[3], row[4])
end

owner_file.each do |row|
    DB.execute("INSERT INTO owner (name, address) VALUES (?, ?)", row[0], row[1])
end

walk_file.each do |row|
    DB.execute("INSERT INTO walk (dog_id, walker_id, date, time, price, length, status, rating) VALUES (?, ?, ?, ?, ?, ?, ?, ?)", row[0], row[1], row[2], row[3], row[4], row[5], row[6], row[7])
end

walker_file.each do |row|
    DB.execute("INSERT INTO walker (name, experience) VALUES (?, ?)", row[0], row[1])
end




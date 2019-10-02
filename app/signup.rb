require_relative '../config/environment'

def signup(type)

    loop do
        username = prompt.ask("Please enter your username:")#{|q| q.validate /\S\z/, 'Please enter a valid username(Spaces are not allowed)'}
        break if !user.find_by_username
        puts "That username is already taken"
    end

    password = prompt.mask("Please enter your password:")#{|q| q.validate /\w\z/, 'Please enter a valid password(Only alphanumeric characters are allowed!)'}

    User.create(username: username, password: password, user_type: type)

end
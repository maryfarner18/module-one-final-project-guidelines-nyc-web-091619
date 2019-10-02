require_relative '../config/environment'

def signup(type)
    prompt= TTY::Prompt.new
    username = nil
    loop do
        username = prompt.ask("Please enter a username:")#{|q| q.validate /\S\z/, 'Please enter a valid username(Spaces are not allowed)'}
        break if !User.find_by(username: username)
        puts "That username is already taken"
    end

    password = prompt.mask("Please enter a password:")#{|q| q.validate /\w\z/, 'Please enter a valid password(Only alphanumeric characters are allowed!)'}

    User.create(username: username, password: password, user_type: type)

end
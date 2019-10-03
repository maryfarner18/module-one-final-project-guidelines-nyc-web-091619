require_relative '../config/environment'

def startup
    system 'clear'
    prompt= TTY::Prompt.new
    has_account = prompt.select("Hello Dog Lover, do you have an account with us?", %w(Yes No Exit))
    if has_account == "Yes"
        user = nil
        loop do
            username = prompt.ask("Please enter your username:")#{|q| q.validate /\S\z/, 'Please enter a valid username(Spaces are not allowed)'}
            password = prompt.mask("Please enter your password:")#{|q| q.validate /\w\z/, 'Please enter a valid password(Only alphanumeric characters are allowed!)'}
            user = User.find_by(username: username, password: password)
            if user
                if user.user_type == "Owner"
                    user.run_owner
                else
                    user.run_walker
                end

                break
            end
            puts "Incorrect username & combination. Try again"
        end 
    elsif has_account == "No"
        puts "Great, let's make an account!"
        if !create_account
            startup
        end
    else
        exit_app
    end     
end  #END STARTUP
        
def create_account #else create account
    prompt= TTY::Prompt.new

    user_type = prompt.select("Are you an owner or a walker?", ["Owner", "Walker", "WoofImmaDog", "Go Back"])
    if user_type == "Go Back"
        return false
    elsif user_type == "Owner"
        
        user = signup("Owner")
        
        #CREATE OWNER
        name = prompt.ask("Please enter your full name:")#{|q| q.validate /\S\z/, 'Please enter a valid username(Spaces are not allowed)'}
        address = prompt.ask("Please enter your address:")#{|q| q.validate /\S\z/, 'Please enter a valid username(Spaces are not allowed)'}
        owner = Owner.create(name: name, address: address, user_id: user.id)

        prompt.ask("Let's add some dogs...hit enter to continue")
        system 'clear'
        owner.add_dogs

        # while prompt.select("Do you have a dog to add?", %w(Yes No)) == "Yes"
        #     dog_name = prompt.ask("Please enter your dog's name:")
        #     breed = prompt.ask("Please enter your dog's breed:")
        #     age = prompt.slider("Please enter your dog's age:", max:25, step: 0.5, default: 5, format: "|:slider| %.1f")
        #     gender = prompt.select("Is it a male or female?", %w(Male Female))
        #     notes = prompt.ask("Please enter anything we should know about your doggo:")

        #     doggo = Dog.create(name: dog_name, breed: breed, age: age, gender: gender, notes: notes, owner_id: owner.id)
        # end

        system 'clear'
        prompt.ask("All set, hit enter to get started!")
        user.run_owner

        
    elsif user_type == "Walker"

        user = signup("Owner")
        
        #CREATE WALKER
        name = prompt.ask("Please enter your full name:")#{|q| q.validate /\S\z/, 'Please enter a valid username(Spaces are not allowed)'}
        experience = prompt.slider("Please enter your years of experience:", max: 80, step: 1, default: 5, format: "|:slider| %d years")
        walker = Walker.create(name: name, experience: experience, user_id: user.id)

        puts "All set, logging in!"
        user.run_walker

    else
        puts "You don't have thumbs, you're a doggo!"
        create_account
        #call exit function
    end
end #END CREATE ACCOUNT
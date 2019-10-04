require_relative '../../config/environment'
  
class User < ActiveRecord::Base
    belongs_to :owner
    belongs_to :walker

    def run_owner
        
        owner = Owner.find_by(user_id: self.id)
        message = "\t\t\t\t\t\t\tWelcome, #{owner.name}!\n"
         #SOME NOISE
        animation('walkingdog', 3, 10, 0.05, 10, message)
        puts "\n"
         #SOME NOISE

        give_owner_options
    end

    def give_owner_options
        reload
        prompt= TTY::Prompt.new
        owner = Owner.find_by(user_id: self.id)
        message = "\t\t\t\t\t\t\tWelcome, #{owner.name}!\n"
        animation('walkingdog', 1, 1, 0.05, 10, message)
       

        if owner.dogs == []
            puts "Sorry you don't have any doggos!"
            #play "hmmmmmmm"
            `afplay ./app/audio/hmm.m4a`
            
            add = prompt.select("Do you want to add a dog?", %w(Yes No))
            if add == "Yes"
                owner.add_dogs
                run_owner
            else
                puts "Ok, bye bye then!"
                prompt.ask("Hit enter when done")
                exit_app
            end

        else

            ####LOOP TILL THEY CHOOSE TO EXIT! ##############
            options = ["See My Dogs", "Request a Walk", "See Upcoming Walks", "Rate a Walk", "See Past Walks", "Cancel a Walk", "See Walks Currently In Progress", "Add a Dog", "Exit"]
            action = prompt.select("What would you like to do?", options, per_page: 10)

            case action
            when options[0] #see dogs
                owner.see_my_dogs
                #play woof
                `afplay ./app/audio/woof.mp3`
                prompt.ask("Hit enter when done")
                give_owner_options

            when options[1] #request walk
                if owner.request_walk
                    #play woof
                    `afplay ./app/audio/woof.mp3` 
                    prompt.ask("Hit enter when done")
                end
                give_owner_options

            when options[3] #rate walk
                if owner.rate_walk
                    prompt.ask("Hit enter when done")
                end
                give_owner_options
            
            when options[5] #cancel walk
                if owner.cancel_walk
                    #play SAD NOISE
                    `afplay ./app/audio/sad_noise.mp3`
                    prompt.ask("Hit enter when done")
                end
                give_owner_options
        
            when options[6] #see in progress
                owner.walks_in_progress
                prompt.ask("Hit enter when done")
                give_owner_options

            when options[2] #see upcoming
                puts "Upcoming Walks:"
                puts owner.upcoming_walks
                prompt.ask("Hit enter when done")
                give_owner_options

            when options[4] #see past
                puts "Past Walks:"
                puts owner.past_walks
                prompt.ask("Hit enter when done")
                give_owner_options

            when options[7] #add dogs
                owner.add_dogs
                give_owner_options

            when options[8] #exit
                exit_app
            end
        end
        
    end #END OWNER OPTIONS


    def run_walker
        reload
        walker = Walker.find_by(user_id: self.id)
        message = "\t\t\t\t\t\t\tWelcome, #{walker.name}!\n"
         #SOME NOISE
        animation('walkingdog', 3, 10, 0.05, 10, message)
        puts "\n"
         #SOME NOISE

        give_walker_options
    end

    def give_walker_options
        reload
        prompt= TTY::Prompt.new
        walker = Walker.find_by(user_id: self.id)

        message = "\t\t\t\t\t\t\tWelcome, #{walker.name}!\n"
        animation('walkingdog', 1, 1, 0.05, 10, message)
            
        options = ["See Current Walk", "See Upcoming Walks", "Start a Walk", "End a Walk", "Cancel A Walk", "See Past Walks", "Exit"]
        action = prompt.select("What would you like to do?", options, per_page: 10)
            
        case action
        when options[0] #current walk
            puts "Current Walks:"
            walker.current_walk
            puts walker.current_walk
            prompt.ask("Hit enter when done")
            give_walker_options
            
        when options[2] #start walk
            if walker.start_walk
                #play woof
                `afplay ./app/audio/woof.mp3`
                prompt.ask("Hit enter when done")
            end
            give_walker_options

        when options[3] #end walk
            if walker.finish_walk
                puts "Don't forget to fill up #{Walk.find(id).dog.name}'s waterbowl!"
                `afplay ./app/audio/dog_drinking.mp3`
                `afplay ./app/audio/end_walk.mp3`
                prompt.ask("Hit enter when done")
            end
            give_walker_options

        when options[4] #cancel walk
            if walker.cancel_walk
                #play SAD NOISE
                `afplay ./app/audio/sad_noise.mp3`
                prompt.ask("Hit enter when done")
            end
            give_walker_options

        when options[1] #upcoming walks
            puts "Upcoming Walks:"
            puts walker.upcoming_walks
            prompt.ask("Hit enter when done")
            give_walker_options
            
        when options[5] #past walks
            puts "Past Walks:"
            puts walker.past_walks

            prompt.ask("Hit enter when done")
            give_walker_options
            
        when options[6] #exit
            exit_app
            
        end

    end #END WALKER OPTIONS

end



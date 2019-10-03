require_relative '../../config/environment'
  
class User < ActiveRecord::Base
    belongs_to :owner
    belongs_to :walker

    def run_owner
        prompt= TTY::Prompt.new

        #identify which owner you are 
        owner = Owner.find_by(user_id: self.id)
        system "clear"
        puts "Welcome, #{owner.name}!"
        
        if owner.dogs == []
            puts "Sorry you don't have any doggos!"
            add = prompt.select("Do you want to add a dog?", %w(Yes No))
            if add
                owner.add_dogs
                run_owner
            else
                puts "Ok, bye bye then!"
                prompt.ask("Hit enter when done")
                exit_app
            end
        end

    
        ####LOOP TILL THEY CHOOSE TO EXIT! ##############
        # loop do 
        options = ["See my dogs", "Request a walk", "Rate a walk", "Cancel a walk", "See walks currently in progress", "See Upcoming Walks", "See past walks", "Exit"]
        action = prompt.select("What would you like to do?", options, per_page: 10)
        system "clear"

        case action
        when options[0] #see dogs
            owner.see_my_dogs
            prompt.ask("Hit enter when done")
            run_owner

        when options[1] #request walk
            owner.request_walk
            prompt.ask("Hit enter when done")
            run_owner

        when options[2] #rate walk
            owner.rate_walk
            prompt.ask("Hit enter when done")
            run_owner
        
        when options[3] #cancel walk
            owner.cancel_walk
            prompt.ask("Hit enter when done")
            run_owner
    
        when options[4] #see in progress
            owner.walks_in_progress
            prompt.ask("Hit enter when done")
            run_owner

        when options[5] #see upcoming
            puts "Upcoming Walks:"
            puts owner.upcoming_walks
            prompt.ask("Hit enter when done")
            run_owner

        when options[6] #see past
            puts "Past Walks:"
            puts owner.past_walks
            prompt.ask("Hit enter when done")
            run_owner

        when options[7] #exit
            exit_app
        end
        
    end #END RUN OWNER


    def run_walker
        prompt= TTY::Prompt.new
        
        walker = Walker.find_by(user_id: self.id)
        system "clear"
        puts "Welcome, #{walker.name}!"

        # loop do 
            
            options = ["See current walk", "Start a Walk", "End a Walk", "Cancel A Walk", "See Upcoming Walks", "See Past Walks", "Exit"]
            action = prompt.select("What would you like to do?", options, per_page: 10)
             
            case action
            when options[0] #current walk
                puts "Current Walks:"
                walker.current_walk
                puts walker.current_walk
                prompt.ask("Hit enter when done")
                run_walker
               
            when options[1] #start walk
                walker.start_walk
                prompt.ask("Hit enter when done")
                run_walker

            when options[2] #end walk
                walker.finish_walk
                prompt.ask("Hit enter when done")
                run_walker

            when options[3] #cancel walk
                walker.cancel_walk
                prompt.ask("Hit enter when done")
                run_walker

            when options[4] #upcoming walks
                puts "Upcoming Walks:"
                puts walker.upcoming_walks
                prompt.ask("Hit enter when done")
                run_walker
                
            when options[5] #past walks
                puts "Past Walks:"
                puts walker.past_walks
                prompt.ask("Hit enter when done")
                run_walker
                
            when options[6] #exit
                exit_app
                
            end

        #end

    end #END RUN WALKER

end



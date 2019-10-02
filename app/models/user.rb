require_relative '../../config/environment'

class User < ActiveRecord::Base
    belongs_to :owner
    belongs_to :walker

    def run_owner
        prompt= TTY::Prompt.new

        #identify which owner you are 
        owner = Owner.find_by(user_id: self.id)
        puts "Welcome, #{owner.name}!"

        ####LOOP TILL THEY CHOOSE TO EXIT! ##############
        loop do 
            options = ["See my dogs", "Request a walk", "Rate a walk", "Cancel a walk", "See walks currently in progress", "See Upcoming Walks", "See past walks", "Exit"]
            action = prompt.select("What would you like to do?", options, per_page: 10)
            system "clear"

            case action
            when options[0] #see dogs
                owner.see_my_dogs

            when options[1] #request walk
                owner.request_walk

            when options[2] #rate walk
                owner.rate_walk
            
            when options[3] #cancel walk
                owner.cancel_walk
     
            when options[4] #see in progress
                owner.walks_in_progress
   

            when options[5] #see upcoming
                puts "Upcoming Walks:"
                puts owner.upcoming_walks

            when options[6] #see past
                puts "Past Walks:"
                puts owner.past_walks

            when options[7] #exit
                exit_app
                return
            end

            prompt.ask("Hit enter when done")
            system "clear"
        end
        
    end #END RUN OWNER


    def run_walker
        prompt= TTY::Prompt.new
        
        walker = Walker.find_by(user_id: self.id)
        puts "Welcome, #{walker.name}!"

        loop do 

            options = ["See current walk", "Start a Walk", "End a Walk", "Cancel A Walk", "See Upcoming Walks", "Exit"]
            action = prompt.select("What would you like to do?", options, per_page: 10)
            
            case action
            when options[0] #current walk
                walker.current_walk
               
            when options[1] #start walk
                walker.start_walk

            when options[2] #end walk
                walker.finish_walk

            when options[3] #cancel walk
                walker.cancel_walk

            when options[4] #upcoming walks
                walker.upcoming_walks
                
            when options[5] #exit
                exit_app
                return
            end

            prompt.ask("Hit enter when done")
            system "clear"

        end

    end #END RUN WALKER

end



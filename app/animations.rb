# require_relative './ascii/dog1.rb'
require_relative '../config/environment.rb'



def animation(file_prefix, loop_times, num_files, delay, last_frame, message)
  
  cursor = TTY::Cursor

  loop_times.times do
    i=0
    while i < num_files
      cursor.move_to
      system 'clear'
      puts "\n"
      puts "#{message}\n"
      # print "\033[2J"
      File.foreach("./app/ascii/#{file_prefix}#{i}.txt") { |f| puts f }
      sleep(delay)
      i += 1
    end
  end
end

  ##CREDIT
  #https://sammysteiner.github.io/blog/2017/04/13/bringing-terminal-applications-to-life-cli-animations-with-ruby/
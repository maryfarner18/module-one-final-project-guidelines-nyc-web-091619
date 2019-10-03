# require_relative './ascii/dog1.rb'

def animation
    2.times do
    i=1
    while i < 4
        puts "hi"
        print "\033[2J"
        File.open("dog#{i}.rb")
        IO.foreach("dog#{i}.rb") { |line| puts line }
        sleep(0.03)
      end
    end
    # i = 1
    
    #   print "\033[2J"
    #   File.foreach("ascii_animation/#{i}.rb") { |f| puts f }
    #   sleep(0.03)
    #   i += 1
    # end
end

  ##CREDIT
  #https://sammysteiner.github.io/blog/2017/04/13/bringing-terminal-applications-to-life-cli-animations-with-ruby/
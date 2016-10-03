class Command_Line_Interface

	def welcome
		puts "Welcome to Tic-Tac-Toe!"
	end

	def gamemode
		puts "--Choose a game mode--"
		puts "H stands for Human; C stands for Computer."
		print "HvH, HvC, CvH, CvC, or wargames >> "
		input = gets.chomp.downcase
		until valid_gamemode?(input)
			print "Invalid. enter HvH, HvC, CvH, CvC, or wargames\n>> "
			input = gets.chomp.downcase
		end
		input
	end

	def valid_gamemode?(input)
		%w{hvh hvc cvh cvc wargames wg war}.include?(input)
	end

	def play_again?
		puts "\nWould you like to play again? (y/n): "
		input = gets.chomp.downcase
		if input == "y" || input == "yes"
			start_game
		elsif input == "n" || input == "no"
			puts "Goodbye!"
		else 
			puts "I'll take that as a no."
		end	
	end

	def wargames
		games = (1..100).each_with_object([]) do |wargame, results|
			results << Game.new(Players::Computer.new("X"), Players::Computer.new("O")).play("wargames")
		end
		puts "X wins: #{games.count("X")}"
		puts "O wins: #{games.count("O")}"
		puts "Draws: #{games.count(nil)}"
		puts "Everyone loses."
	end

	def start_game
		mode = gamemode
		case mode
			when "wargames" || "wg" || "war"
				wargames
			when "hvh"
				Game.new.play
			when "cvc"
				Game.new(Players::Computer.new("X"), Players::Computer.new("O")).play
			when "hvc"
				Game.new(Players::Human.new("X"), Players::Computer.new("O")).play
			when "cvh"
				Game.new(Players::Computer.new("X"), Players::Human.new("O")).play
		end
	end		
end
class Game

	attr_accessor :board, :player_1, :player_2

	WIN_COMBINATIONS = [
		[0,1,2],
		[3,4,5],
		[6,7,8],
		[0,3,6],
		[1,4,7],
		[2,5,8],
		[0,4,8],
		[6,4,2]
	]

	def initialize(
			player_1 = Players::Human.new("X"), 
			player_2 = Players::Human.new("O"),
			board = Board.new 
		)

		@board = board
		@player_1 = player_1
		@player_2 = player_2
	end

	def current_player
		turn = @board.turn_count + 1
		if turn % 2 != 0
			player_1.token == "X" ? player_1 : player_2
		else
			player_1.token == "O" ? player_1 : player_2
		end
	end

	def over?
		draw? || won?
	end

	def won?
		!winning_combo.nil?
	end

	def draw?
		@board.full? && !won?
	end

	def winner
		won? ? @board.cells[winning_combo[0]] : nil
	end

	def turn
		move = current_player.move(@board)
		until @board.valid_move?(move)
			raise "Computer attempted invalid move" if current_player.is_a?(Players::Computer)
			puts "invalid"
			move = current_player.move(@board)
		end
		@board.update(move,current_player)
	end

	def play(gamemode = "normal")
		@board.display
		unless gamemode == "wargames"
			until over?
				turn
				@board.display
			end
			if won?
				puts "Congratulations #{winner}!"
			elsif draw?
				puts "Cats Game!"
			end

		else
			until over?
				turn
			end
			winner
		end
	end
				

	private

	def winning_combo
		WIN_COMBINATIONS.find do |combo|
			combo.all?{|i| @board.cells[i] == "X"} || combo.all?{|i| @board.cells[i] == "O"}
		end
	end

end

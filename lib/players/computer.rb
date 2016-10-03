module Players

	class Computer < Player

		attr_reader :board, :focus, :weights
		# focus: the cell the AI is evaluating
		# weights: hash of weights of all the possible moves


		BASE_WEIGHTS = {
			4 => 2, # Center cell has highest strategic value
			0 => 1, 2 => 1, 6 => 1, 8 => 1, # Corners are second
			1 => 0, 3 => 0, 5 => 0, 7 => 0  # Sides are last
		}

		# Returns the best move on a given board (formatted)
		def move(board)
			@weights = {}
			@board = board
			evaluate_moves
			(select_move + 1).to_s
		end

		private

		# Returns a numerical representation of the strategic value of the focus
		def weigh_focus
			@weights[@focus] = BASE_WEIGHTS[@focus] + offensive_val + defensive_val
		end

		# Chooses which move to make
		def evaluate_moves
			possible_moves.each do |move| # Evaluate every possible move
				@focus = move
				weigh_focus
			end
		end

		def select_move
			options = @weights.select {|move,weight| @weights.values.all? { |w| weight >= w } } # Compile the best moves
			choice = options.keys.sample # Randomly choose one of the best moves 
			puts "computer: #{choice + 1}"
			choice
		end

		# Returns array of possible moves
		def possible_moves
			@board.cells.map.with_index {|cell, i| @board.taken?(i + 1) ? nil : i}.compact
		end

		#Returns the weight corresponding to the offensive worth of the focus
		def offensive_val
			Game::WIN_COMBINATIONS.each_with_object([0]) { |combo, val|
				if combo.include?(@focus)
					friendly_pop = combo.count {|c| @board.cells[c] == self.token}
					hostile_pop = combo.count {|c| @board.cells[c] != self.token && @board.cells[c] != " "}
					val[0] +=  4 if friendly_pop == 1 && hostile_pop == 0 # Closer to a win == higher offensive value
					val[0] += 10 if friendly_pop == 2 && hostile_pop == 0
					#binding.pry
				end
			}.first
		end

		# Returns the weight corresponding to the defensive worth of the focus
		def defensive_val
			Game::WIN_COMBINATIONS.each_with_object([0]) { |combo, val|
				if combo.include?(@focus)
					friendly_pop = combo.count {|c| @board.cells[c] == self.token}
					hostile_pop = combo.count {|c| @board.cells[c] != self.token && @board.cells[c] != " "}
					val[0] += 2 if hostile_pop == 1 && friendly_pop == 0 # Enemy closer to a win == higher defensive value
					val[0] += 8 if hostile_pop == 2 && friendly_pop == 0
				end
			}.first
		end

		# def long_term_val
		# 	 next_board = @board
		# 	 next_board[@focus] = self.token

		#######

		# def defensive_val
		# 	evaluate_board { |val, friendly_pop, hostile_pop|
		# 		val[0] += 2 if hostile_pop == 1 && friendly_pop == 0 # Enemy closer to a win == higher defensive value
		# 		val[0] += 8 if hostile_pop == 2 && friendly_pop == 0
		# 	}.first
		# end

		# def offensive_val
		# 	evaluate_board { |val, friendly_pop, hostile_pop|
		# 		val[0] +=  4 if friendly_pop == 1 && hostile_pop == 0 # Closer to a win == higher offensive value
		# 		val[0] += 10 if friendly_pop == 2 && hostile_pop == 0
		# 	}.first
		# end

		# def evaluate_board 
		# 	Game::WIN_COMBINATIONS.each_with_object([0]) do |combo, val|
		# 		if combo.include?(@focus)
		# 			friendly_pop = combo.count {|c| @board.cells[c] == self.token}
		# 			hostile_pop = combo.count {|c| @board.cells[c] != self.token && @board.cells[c] != " "}
		# 			yield val, friendly_pop, hostile_pop
		# 		end
		# 	end
		# end

		#########

		# def defensive_val
		# 	evaluate_board do |val, friendly_pop, hostile_pop|
		# 		val += 2 if hostile_pop >= 1 && friendly_pop == 0 # Enemy closer to a win == higher defensive value
		# 		val += 8 if hostile_pop == 2 && friendly_pop == 0
		#     val
		# 	end
		# end

		# def offensive_val
		# 	evaluate_board do |val, friendly_pop, hostile_pop|
		# 		val += 4 if friendly_pop >= 1 && hostile_pop == 0 # Closer to a win == higher offensive value
		# 		val += 6 if friendly_pop == 2 && hostile_pop == 0
		#     val
		# 	end
		# end

		# def evaluate_board 
		# 	Game::WIN_COMBINATIONS.inject(0) do |val, combo|
		# 		if combo.include?(@focus)
		# 			friendly_pop = combo.count {|c| @board.cells[c] == self.token}
		# 			hostile_pop = combo.count {|c| @board.cells[c] != self.token && @board.cells[c] != " "}
		# 			puts val
		# 			val = yield val, friendly_pop, hostile_pop
		# 		end
		# 	end
		# end		

	end
end

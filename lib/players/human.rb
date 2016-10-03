module Players

	class Human < Player

		def move(board)
			print "make a move: "
			gets.chomp
		end

	end

end

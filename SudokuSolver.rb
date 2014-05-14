module Sudoku

	class Puzzle
		
		ASCII = ".123456789"
		BIN = "/000/001/002/003/004/005/006/007/010/011"

		def initialize(lines)
			#The if else initializes s as a string, whether it started as a string array or just a string
			if lines.respond_to? :join #basically, if it has a join method, it is probably an array
				s = lines.join #so join it into one string
			else
				s = lines.dup #otherwise, just save lines as s
			end
			s.gsub!(/\s/, "") #replace all whitespace with empty string
			#Make sure input is good
			raise Invalid, "Grid is the wrong size" unless s.size == 81
			if i = s.index(/[^123456789\.]/)
				raise Invalid, "Illegal character #{s[i,1]} in puzzle"
			end
			s.tr!(ASCII, BIN) #Translates ascii into bytess
			@grid = s.unpack('c*') #"unpacks" bytes into an array of numbers
			
			#raise Invalid, "Initial puzzle has duplicates" if has_duplicates?
			
		end
		
		def to_s
			(0..8).collect{|r| @grid[r*9,9].pack('c9')}.join("\n").tr(BIN,ASCII)
		end
		
		def dup
			copy = super
			@grid = @grid.dup
			copy
		end
		
		def [](row,col)
			@grid[row*9 + col]
		end
		
		def []=(row,col,newvalue)
			unless (0..9).include? newvalue
				raise Invalid, "illegal cell value"
			end
			@grid[row*9 + col] = newvalue
		end
		
		
		
	end
	
end

puts Sudoku::Puzzle.new("6	2	2	7	5	7	4	4	3	1	5	9	3	1	3	9	5	4	8	7	1	2	6	8	4	1	7	7	5	7	3	8	6	3	1	6	5	5	4	7	8	4	6	3	4	3	3	6	2	9	2	7	3	1	1	4	9	7	2	3	5	7	1	4	2	2	9	2	7	3	6	5	6	8	2	8	6	4	8	3	4")
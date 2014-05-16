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
			
			@grid = Array.new
			s.each_char do |c|
			@grid.push(c)
			
			end
		end

		def to_s
		#print and format the grid
			s = ""
			(0..80).each do |i|
				if i % 3 == 0 then
					s = s + " "
				end
				if i % 9 == 0
					s = s +"\n"
				end
				if i % 27 == 0
					s = s +"\n"
				end
				s = s + @grid[i].to_s
			end
			s
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

		BoxOfIndex = [0,0,0,1,1,1,2,2,2,0,0,0,1,1,1,2,2,2,0,0,0,1,1,1,2,2,2,3,3,3,4,4,4,5,5,5,3,3,3,4,4,4,5,5,5,3,3,3,4,4,4,5,5,5,6,6,6,7,7,7,8,8,8,6,6,6,7,7,7,8,8,8,6,6,6,7,7,7,8,8,8].freeze #this is the gameboard, it is frozen so it can't be modified, and since the first letter of the name is capitol it is a constant

		def each_unknown
			0.upto 8 do |row|  #for each row
				0.upto 8 do |col|   #for each column
					index = row*9+col   #get the index
					next if @grid[index] != "."   #move on if it is known
					box = BoxOfIndex[index]   #otherwise get the box
					yield row, col, box   #then return the spot the number is in
				end
			end
		end

		def has_duplicates?
			0.upto(8) {|row| return true if rowdigits(row).uniq! }
			0.upto(8) {|col| return true if coldigits(col).uniq! }
			0.upto(8) {|box| return true if boxdigits(box).uniq! }
			false #otherwise, returns false
		end

		#an array of ok sudoku digits
		AllDigits = [1,2,3,4,5,6,7,8,9].freeze

		def possible(row, col, box)
			#returns the possible digits for the cell
			AllDigits - (rowdigits(row) + coldigits(col) + boxdigits(box))
		end

		private #all methods under here are private to the class

		def rowdigits(row) #returns an array of the known values in the row
			@grid[row*9,9] - [0]
		end

		def coldigits(col) #same thing but with columns
			result = [] #start with empty array
			col.step(80, 9) {|i| #loop through columns
				v = @grid[i]  #get value of the cell
				result << v if (v != 0)  #add it to the array if it isn't zero
			}
			result
		end

		#a list of the top right corners of all the boxes
		BoxToIndex = [0,3,6,27,30,33,54,57,60].freeze

		#return a list of known digits in a box
		def boxdigits(b)
			i = BoxToIndex[b]
			#now return an array of values with the 0 elements removed
			[
				@grid[i], @grid[i+1], @grid[i+2],
				@grid[i+9], @grid[i+10], @grid[i+11],
				@grid[i+18], @grid[i+19], @grid[i+20]
			] - [0]
		end
	end#thus, the puzzle class ends

	#an exception class, incorrect input
	class Invalid < StandardError
	end

	#an exception class, over-constrained puzzle/not solvable
	class Impossible < StandardError
	end

	#goes through the puzzle setting values until it can't set values
	def Sudoku.scan(puzzle)
		unchanged = false #looping variable

		until unchanged
			unchanged = true
			rmin,cmin,pmin = nil
			min = 10
			puzzle.each_unknown do |row, col, box|
				p = puzzle.possible(row,col,box)
				case p.size
				when 0 #no possible values, overconstrained puzzle
					raise Impossible
				when 1 #only one value, it must be correct so set it in the puzzle
					puzzle[row,col] = p[0]
					unchanged = false
				else
					if unchanged && p.size < min
						min = p.size
						rmin, cmin, pmin = row, col, p
					end
				end
			end
		end
		return rmin, cmin, pmin
	end

	#now a method that solves the puzzle
	def Sudoku.solve(puzzle)
		puzzle = puzzle.dup #this way we don't mess with the original
		r,c,p = scan(puzzle)

		return puzzle if r == nil

		p.each do |guess| #loop through the guesses for each empty cell
			puzzle[r,c] = guess

			begin #now we try to recursively solve the modified puzzle
				return solve(puzzle)
			rescue Impossible
				next
			end
		end

		#if we get this far, we messed up somewhere
		raise Impossible
	end
	puts "Input filename or classpath:"
	input_file = File.open(gets)
	
	puts Sudoku.solve(Puzzle.new(".3..52...2..7..63..9...3.1.3458.9....7..1..8....3.4795.6.2...5..83..6..4...14..6."))
end
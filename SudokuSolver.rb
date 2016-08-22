###This is mostly not my program. I have tweaked it a bit, but I cannot take the credit. And unfortunately I do not know where it originally came from
### so if you happen to know which book this program is from, please let me know so I can give them the credit.
#This program reads a sudoku board from a file inputted upon running the program, and solves the puzzle.
#The input file needs to contain 81 digits, known values are digits between 1 and 9 inclusive, and unknown values are represented by . Whitespace is
#trimmed automatically

module Sudoku

	class Puzzle

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
			#this loop fills @grid with the numbers
			@grid = Array.new
			s.each_char do |c|
				@grid.push(c)
			end
			if has_duplicates?
				raise Invalid, "Initial puzzle has duplicates" 
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
		AllDigits = ["1","2","3","4","5","6","7","8","9"].freeze
		def []=(row,col,newvalue)
			unless AllDigits.include? newvalue
				raise Invalid, "illegal cell value"
			end
			@grid[row*9 + col] = newvalue
		end

		BoxOfIndex = [0,0,0,1,1,1,2,2,2,0,0,0,1,1,1,2,2,2,0,0,0,1,1,1,2,2,2,3,3,3,4,4,4,5,5,5,3,3,3,4,4,4,5,5,5,3,3,3,4,4,4,5,5,5,6,6,6,7,7,7,8,8,8,6,6,6,7,7,7,8,8,8,6,6,6,7,7,7,8,8,8].freeze #this is the gameboard, it is frozen so it can't be modified, and since the first letter of the name is capitol it is a constant

		def each_unknown
			0.upto 8 do |row|  #for each row
				0.upto 8 do |col|   #for each column
					index = row*9+col   #get the index
					if @grid[index] != "."   #move on if it is known
						next
					end
					box = BoxOfIndex[index]   #otherwise get the box
					yield row, col, box   #then return the spot the number is in
				end
			end
		end

		def has_duplicates?
			#0.upto(8) {|row| return true if rowdigits(row).uniq! }
			#0.upto(8) {|col| return true if coldigits(col).uniq! }
			#0.upto(8) {|box| return true if boxdigits(box).uniq! }
			0.upto(8) do |row| 
				if rowdigits(row).uniq! then
				return true
				end
			end
			0.upto(8) do |col| 
				if coldigits(col).uniq! then
				return true
				end
			end
			0.upto(8) do |box| 
				if boxdigits(box).uniq! then
				return true
				end
			end
			false
		end

		#an array of ok sudoku digits

		def possible(row, col, box)
			#returns the possible digits for the cell
			AllDigits - (rowdigits(row) + coldigits(col) + boxdigits(box))
		end

		private #all methods under here are private to the class

		def rowdigits(row) #returns an array of the known values in the row
			@grid[row*9,9] - ["."]
		end

		def coldigits(col) #same thing but with columns
			result = [] #start with empty array
			col.step(80, 9) {|i| #loop through columns
				v = @grid[i]  #get value of the cell
				result << v if (v != ".")  #add it to the array if it isn't zero
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
			] - ["."]
		end
	end#thus, the puzzle class ends

	#an exception class, incorrect input
	class Invalid < StandardError
	end

	#an exception class, over-constrained puzzle/not solvable
	class Impossible < StandardError
	end

	#finds the first unset cell and gets the location and an array of possible values for the array
	def Sudoku.scan(puzzle)
		unchanged = false #looping variable

		until unchanged
			unchanged = true
			rmin,cmin,pmin = nil
			min = 10
			puzzle.each_unknown do |row, col, box|
				p = puzzle.possible(row,col,box)
				#puts row.to_s + " " + col.to_s + " " + p.to_s + "p" good line for troubleshooting
				case p.size
				when 0 #no possible values, overconstrained puzzle
					#puts puzzle
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
		return rmin, cmin, pmin #pmin is possible values, an array
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

	def Sudoku.main
		in_file = ""
		puts "Input filename: "
		in_file = gets.chomp
		file = File.new(in_file, "r")
		nums = file.readlines.join.chomp
		puts Sudoku.solve(Puzzle.new(nums))
	end
	
	Sudoku.main
	
end

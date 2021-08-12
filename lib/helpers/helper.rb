module Helper
	## The is_i? method checks whether or not the argument passed to it is a string containing a number
	## This is more useful than using is_a? because converting a NaN value to a number will result in 0, which is a potential bug
	def self.is_i?(input)
		/\A[-+]?\d+\z/ === input
	end

	## Check if the grid size is valid
  def self.is_valid_grid_size?(size)
    is_i? size and size.to_i > 0
  end
end

## To run: $ ./bin/toyrobot grid=5,5 visual file=filename.json
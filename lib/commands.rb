module Commands
	

  def self.is_valid?(commands, command)
		commands.keys.include? command
	end

	def self.directions
		[ "NORTH", "WEST", "SOUTH", "EAST" ]
	end

	def self.cli_arguments
		["--v", "-v", "--visual", "-visual"]
	end
end
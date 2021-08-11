module Helper
	def self.is_i?(input)
		/\A[-+]?\d+\z/ === input
	end

  def self.is_valid_grid_size?(size)
    is_i? size and size.to_i > 0
  end
end
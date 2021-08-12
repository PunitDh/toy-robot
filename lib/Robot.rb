require "tty-table"
require_relative "../config/environment.rb"
require_relative "./helpers/commands"
require_relative "./helpers/helper"
require_relative "./helpers/renderer"

class Robot

  attr_accessor :x, :y, :f, :prev_x, :prev_y

  def initialize(x: nil, y: nil, f: nil)
    @x = x
    @y = y
    @prev_x = @x
    @prev_y = @y
    @f = f
  end
  
end
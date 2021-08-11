require "tty-table"
require_relative "../config/environment.rb"
require_relative "./commands"
require_relative "./helper"


class ToyRobot
  
  def initialize(rows: nil, cols: nil, enable_visual: false)
    exit if rows.nil? or cols.nil?
    @grid_size = { rows: rows, cols: cols }
    @grid = []
    @placed = false
    @robot = 1
    @x = nil
    @y = nil
    @prev_x = @x
    @prev_y = @y
    @current_dir = nil
    @visual = enable_visual
    @grid_size[:rows].times { @grid << [] }
    @grid.each { |row| @grid_size[:cols].times { row << nil } }
    print "Initialised a #{@grid_size[:rows]}x#{@grid_size[:cols]} grid."
  end

  def commands
		{
			"PLACE"  => lambda{ |*command| place_robot(command) },
			"MOVE"   => lambda{ |*command| if_has_been_placed_then { move } },
			"LEFT"   => lambda{ |*command| if_has_been_placed_then { rotate(1) } },
			"RIGHT"  => lambda{ |*command| if_has_been_placed_then { rotate(-1) } },
			"REPORT" => lambda{ |*command| if_has_been_placed_then { print_report } },
			"EXIT"   => lambda{ |*command| print "Goodbye."; exit }
		}
	end

  ## Game start loop
  def start
    while true
        print "\nEnter command: "
        command = $stdin.gets.chomp.upcase.split(" ")
        print "You entered: #{command.join(' ')}\n"
        Commands::is_valid?(commands, command[0]) ? execute_command(command) : print("#{command.join(' ')} is an invalid command\n")
        puts @visual ? "\n" + render_table(create_visual_table) + "\n" : nil
    end
  end

  def place_robot(place_arg)
    if place_args_valid?(place_arg.first[1])
      args = place_args_deconstruct(place_arg.first[1])
      if can_be_placed?(args[0].to_i, args[1].to_i)
        place(args[0].to_i, args[1].to_i, args[2])
      else
        print "ERROR: Robot cannot be placed at position #{args[0]}, #{args[1]}"
      end
    else
      print "\nInvalid PLACE arguments\n"
    end
  end

  def print_report
    print "Robot is currently at position #{report[0]},#{@grid_size[:rows]-1-report[1]} facing #{Commands::directions[report[2]]}"
  end

  

  ## Execute command
  def execute_command(command)
    commands[command[0]].call(command)
  end

  ## Check if PLACE arguments are valid arguments
  def place_args_valid?(args)
    return false if args.nil?
    args = place_args_deconstruct(args)
    Helper::is_i?(args[0]) and Helper::is_i?(args[1]) and Commands::directions.include?(args[2])
  end

  ## Deconstruct PLACE arguments and return as an array
  def place_args_deconstruct(args)
    args.delete(' ').split(",")
  end

  ## Check if the robot can be placed at a particular position
  def can_be_placed?(arg0, arg1)
    return false if (arg0 < 0 or arg0 >= @grid_size[:rows] or arg1 < 0 or arg1 >= @grid_size[:cols])
    return true
  end

  ## Place the robot at given position and direction
  def place(x,y,f)
    @x = x
    @y = (@grid_size[:rows] - 1) - y
    @current_dir = Commands::directions.find_index(f)
    set_coords(@y, @x, @robot)
    @placed = true
    print ("Robot has been placed at position #{x},#{y} facing #{f}")
  end

  ## Check if placed, then execute the code block given to it
  def if_has_been_placed_then
    @placed ? yield : print("ERROR: Robot has not been placed yet. Please place the robot first using the PLACE command.")
  end

  ## Depending on the direction, move the robot if it is a valid move
  def move
    case @current_dir
        when 0
            move_if_valid(@y - 1, @x, @robot)
        when 1
            move_if_valid(@y, @x - 1, @robot)
        when 2
            move_if_valid(@y + 1, @x, @robot)
        when 3
            move_if_valid(@y, @x + 1, @robot)
    end
      
  end

  ## If it is a valid move, move the robot, or else print an error
  def move_if_valid(y, x, obj)
    if can_be_placed?(y,x) 
        set_coords(y,x,obj)
        print("Robot has moved 1 step #{Commands::directions[@current_dir]} and is at position #{x},#{@grid_size[:rows]-1-y}")
    else
        print("ERROR: Unable to move any further")
    end
  end

  ## Return the current coordinates and direction
  def report
    [@x, @y, @current_dir]
  end

  ## Rotate the robot
  def rotate(dir)
    if (@current_dir + dir >= Commands::directions.length)
        @current_dir = 0
    elsif (@current_dir + dir < 0)
        @current_dir = Commands::directions.length - 1
    else
        @current_dir += dir
    end
    print "Robot is now facing " + Commands::directions[@current_dir] + "\n"
  end

  ## The setcoords function clears the previous x,y positions, records new positions and places the given object
  def set_coords(y,x,obj)
    @grid[@prev_y][@prev_x] = nil unless (@prev_y.nil? and @prev_x.nil?)
    @prev_x = x
    @prev_y = y
    @x = x
    @y = y
    @grid[y][x] = obj
  end

  def create_visual_table
    table = TTY::Table.new

    @grid.map.with_index do |row, i|
      display_row = []
      row = row.map.with_index { |col, j| display_row << (col.nil? ? "  " : "🤖") }
      table << display_row
    end

    return table
  end

  def render_table(table)
    renderer = TTY::Table::Renderer::Unicode.new(table)
    renderer.border.separator = :each_row
    return renderer.render
  end
end
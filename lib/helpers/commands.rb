require_relative "./helper"
require_relative "../../config/environment.rb"

module Commands

  def directions
		{ 
      "NORTH" => [-1,  0],
      "WEST"  => [ 0, -1],
      "SOUTH" => [ 1,  0],
      "EAST"  => [ 0,  1]
    }
	end

	def self.argvs
		%w(grid visual file)
	end

  def self.check_argvs(argv)
    app_params = { rows: DEFAULT_GRID_ROWS, cols: DEFAULT_GRID_COLUMNS, visual: DEFAULT_ENABLE_VISUAL, input: DEFAULT_INPUT, filename: nil }
    argv.each do |arg|
      
      param = arg.split("=")

      if param[0] == argvs[0]
        if (param[1].nil?)
          puts "ERROR: `#{argvs[0]}` argument found but no grid size was specified."
          exit
        else
          grid_size = param[1].split(",")
          if Helper::is_valid_grid_size?(grid_size[0]) and Helper::is_valid_grid_size?(grid_size[1])
            app_params[:rows] = grid_size[0].to_i
            app_params[:cols] = grid_size[1].to_i
          end
        end
      
      elsif param[0] == argvs[1]
        app_params[:visual] = true
      
      elsif param[0] == argvs[2]
        app_params[:input] = :file
        app_params[:filename] = param[1]
      end

    end

    return app_params
  end

  ## The commands method is a hash of values with lambda functions attached to each. This makes it easier to add new commands to the program.
  def command_list
		{
			"PLACE"  => lambda{ |*command| place_robot(command) },
			"MOVE"   => lambda{ |*command| if_has_been_placed_then { move } },
			"LEFT"   => lambda{ |*command| if_has_been_placed_then { @robot.f = rotate(1) } },
			"RIGHT"  => lambda{ |*command| if_has_been_placed_then { @robot.f = rotate(-1) } },
			"REPORT" => lambda{ |*command| if_has_been_placed_then { print_report } },
			"EXIT"   => lambda{ |*command| print "Goodbye."; exit },
			"SHOW"   => lambda{ |*command| print "\n" + Renderer::render_table(Renderer::create_visual_table(@grid)) + "\n" }
		}
	end

  ## The is_valid? method checks if the given command is in the list of approved commands
  def is_valid?(command)
		command_list.keys.include? command
	end

  ## The place_robot method takes arguments related to its position and direction it is facing. It returns either true or false depending on whether
  ## it succeeded or failed in placing the robot
  def place_robot(place_arg)
    if place_args_valid?(place_arg.first[1])
      args = place_args_deconstruct(place_arg.first[1])
      if can_be_placed?(args[0].to_i, args[1].to_i)
        @robot = place(args[0].to_i, args[1].to_i, args[2])
        return true
      else
        print "ERROR: Robot cannot be placed at position #{args[0]}, #{args[1]}"
        return false
      end
    else
      print "\nInvalid PLACE arguments\n"
      return false
    end
  end

  ## The print_report method prints out where the robot currently is and which way it is facing
  def print_report
    puts "Robot is currently at position #{report[0]},#{@rows-1-report[1]} facing #{@robot.f}"
  end

  ## Check if PLACE arguments are valid arguments
  def place_args_valid?(args)
    return false if args.nil?
    args = place_args_deconstruct(args)
    Helper::is_i?(args[0]) and Helper::is_i?(args[1]) and directions.include?(args[2])
  end

  ## Deconstruct PLACE arguments and return as an array
  def place_args_deconstruct(args)
    args.delete(' ').split(",")
  end

  ## Check if the robot can be placed at a particular position
  def can_be_placed?(arg0, arg1)
    return false if (arg0 < 0 or arg0 >= @rows or arg1 < 0 or arg1 >= @cols)
    return true
  end

  ## Place the robot at given position and direction
  def place(x, y, f)
    @robot ? @grid[@robot.prev_y][@robot.prev_x] = nil : nil
    @robot = Robot.new(x: x, y: y, f: f)
    set_coords(@rows - 1 - @robot.y, @robot.x, @robot)
    print ("Robot has been placed at position #{x},#{y} facing #{f}")
    return @robot
	end

  ## Check if placed, then execute the code block given to it
  def if_has_been_placed_then
    @robot.nil? ? print("ERROR: Robot has not been placed yet. Please place the robot first using the PLACE command.") : yield
  end

  ## Depending on the direction, move the robot if it is a valid move
  def move
    return move_if_valid(@robot.y + directions[@robot.f][0], @robot.x + directions[@robot.f][1], @robot)
  end

  ## If it is a valid move, move the robot, or else print an error
  def move_if_valid(y, x, obj)
    if can_be_placed?(y,x)
      set_coords(y,x,obj)
      print("Robot has moved 1 step #{@robot.f} and is at position #{x},#{@rows-1-y}")
      return true
    else
      print("ERROR: Unable to move any further")
      return false
    end
  end

  ## Return the current coordinates and direction
  def report
    [@robot.x, @robot.y, @robot.f]
  end

  ## Rotate the robot
  def rotate(dir)
    dirs = directions.keys
    current_dir = dirs.find_index(@robot.f)

    if current_dir + dir > (dirs.length - 1)
      current_dir = 0
    elsif current_dir + dir < 0
      current_dir = (dirs.length - 1)
    else
      current_dir += dir
    end

    puts "Robot is now facing #{dirs[current_dir]}\n"
    return dirs[current_dir]
  end

  ## The setcoords function clears the previous x,y positions, records new positions and places the given object
  def set_coords(y,x,obj)
    @grid[obj.prev_y][obj.prev_x] = nil unless (obj.prev_y.nil? and obj.prev_x.nil?)
    obj.x = x
    obj.y = y
    obj.prev_x = x
    obj.prev_y = y
    @grid[y][x] = obj
  end
end
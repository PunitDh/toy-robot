class ToyRobot
    
    def initialize(grid_size: nil)
        exit if grid_size.nil?
        @placed = false
        @robot = 1
        @robot_visual = "🤖"
        @x = nil
        @y = nil
        @prev_x = @x
        @prev_y = @y
        @current_dir = nil
        @grid_size = grid_size
        @grid = []
        @grid_size.times { @grid << [] }
        @grid.each { |row| @grid_size.times { row << nil } }
        @commands   = ["PLACE", "MOVE", "LEFT", "RIGHT", "REPORT", "EXIT"]
        @directions = [ "NORTH", "WEST", "SOUTH", "EAST" ]
        print "Initialised a #{@grid_size}x#{@grid_size} grid."
    end

    ## Game start loop
    def start
        while true
            print "\nEnter command: "
            command = gets.chomp.upcase.split(" ")
            print "You entered: #{command.join(' ')}\n"
            is_valid?(command[0]) ? execute_command(command) : print("#{command.join(' ')} is an invalid command\n")
            print board + "\n"
        end
    end

    ## Check if command is valid
    def is_valid?(command)
        @commands.include? command
    end

    ## Execute command
    def execute_command(command)
        case command[0]
            when "PLACE"
                if place_args_valid?(command[1])
                    args = place_args_deconstruct(command[1])
                    if can_be_placed?(args[0].to_i, args[1].to_i)
                        place(args[0].to_i, args[1].to_i, args[2])
                    else
                        print "ERROR: Robot cannot be placed at position #{args[0]}, #{args[1]}"
                    end
                else
                    print "\nInvalid PLACE arguments\n"
                end
            when "MOVE"
                if_has_been_placed_then { move }
            when "REPORT"
                if_has_been_placed_then { print "Robot is currently at position #{report[0]},#{@grid_size-1-report[1]} facing #{@directions[report[2]]}" }
            when "LEFT"
                if_has_been_placed_then { rotate(1) }
            when "RIGHT"
                if_has_been_placed_then { rotate(-1) }
            when "EXIT"
                print "Goodbye."
                exit
        end
    end

    ## Check if PLACE arguments are valid arguments
    def place_args_valid?(args)
        args = place_args_deconstruct(args)
        is_i?(args[0]) and is_i?(args[1]) and @directions.include?(args[2])
    end

    ## Deconstruct PLACE arguments and return as an array
    def place_args_deconstruct(args)
        args.delete(' ').split(",")
    end

    ## Check if the robot can be placed at a particular position
    def can_be_placed?(arg0, arg1)
        return false if (arg0 < 0 or arg0 >= @grid_size or arg1 < 0 or arg1 >= @grid_size)
        return true
    end

    ## Place the robot at given position and direction
    def place(x,y,f)
        @x = x
        @y = (@grid_size - 1) - y
        @current_dir = @directions.find_index(f)
        set_coords(@y, @x, @robot)
        @placed = true
    end

    ## Check if placed, then execute the code block given to it
    def if_has_been_placed_then
        @placed ? yield : print("ERROR: Robot has not been placed yet. Please place the robot first using the PLACE command.")
    end

    ## A method to check if the input is a number in a string
    def is_i?(input)
        /\A[-+]?\d+\z/ === input
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
        can_be_placed?(y,x) ? set_coords(y,x,obj) : print("ERROR: Unable to move any further")
    end

    ## Return the current coordinates and direction
    def report
        [@x, @y, @current_dir]
    end

    ## Rotate the robot
    def rotate(dir)
        if (@current_dir + dir >= @directions.length)
            @current_dir = 0
        elsif (@current_dir + dir < 0)
            @current_dir = @directions.length - 1
        else
            @current_dir += dir
        end
        print "Robot is now facing " + @directions[@current_dir] + "\n"
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

    ## The board is dynamically generated based on grid size, cell size and robot positions
    def board
        cell_size = 5
        grid_indent = "\t" * 3
        top_left_corner = "┌"
        top_right_corner = "┐"
        bottom_left_corner = "└"
        bottom_right_corner = "┘"
        horizontal_edge = "─"
        vertical_edge = "│"
        horizontal_separator_open = "┬"
        horizontal_separator_close = "┴"
        vertical_separator_open = "├"
        vertical_separator_close = "┤"
        middle_separator = "┼"
        
        board_top = grid_indent + top_left_corner + (((horizontal_edge * cell_size) + horizontal_separator_open) * (@grid_size - 1)) + (horizontal_edge * cell_size) + top_right_corner + "\n"
        board_middle_edge = grid_indent + vertical_separator_open + ((horizontal_edge * cell_size) + middle_separator) * (@grid_size - 1) + (horizontal_edge * cell_size) + vertical_separator_close + "\n"
        board_bottom = grid_indent + bottom_left_corner + (((horizontal_edge * cell_size) + horizontal_separator_close) * (@grid_size - 1)) + (horizontal_edge * cell_size) + bottom_right_corner
        robot_cell = (@current_dir == 3) ? (" " + @robot_visual + "► ") : ((@current_dir == 1) ? "◄" + @robot_visual + "  " : " " + @robot_visual + " " * (cell_size - 3))
        
        board_body = @grid.map.with_index { |row, i|
            render_row(grid_indent, row, cell_size, vertical_edge, (@current_dir == 0 ? " ▲" + " " * (cell_size - 2) : " " * cell_size)) + 
            render_row(grid_indent, row, cell_size, vertical_edge, robot_cell) + 
            render_row(grid_indent, row, cell_size, vertical_edge, (@current_dir == 2 ? " ▼" + " " * (cell_size - 2) : " " * cell_size)) + 
            ((i == @grid_size - 1) ? board_bottom : board_middle_edge)
        }.join("")

        "\n" + board_top + board_body + "\n"
    end

    def render_row(grid_indent, row, cell_size, vertical_edge, render)
        grid_indent + row.map { |cell|
            (vertical_edge + (cell.nil? ? (" " * cell_size) : render))
        }.join("")  + vertical_edge + "\n"
    end
end
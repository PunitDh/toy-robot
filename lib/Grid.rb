require_relative "./helpers/commands"
require_relative "./helpers/renderer"

class Grid
  include Commands

  attr_reader :grid

	def initialize(rows: nil, cols: nil, enable_visual: false, input: nil, filename: nil)
    return false if (rows.nil? or cols.nil? or input.nil?)
		@rows = rows
		@cols = cols
		@enable_visual = enable_visual
    @input = input
    @filename = filename
    @grid = []
    @robot = nil
    @rows.times { @grid << [] }
    @grid.each { |row| @cols.times { row << nil } }
    puts "Initialised a #{@rows}x#{@cols} grid."
    return true
	end

  def start_simulation
    if @input == :cli
      handle_cli_input
    elsif @input == :file
      handle_file_input
    end
  end

  def handle_cli_input
    while true
      print "\nEnter command: "
      command = $stdin.gets.chomp.upcase.split(" ")
      print "You entered: #{command.join(' ')}\n"
      execute_command(command)
      puts @enable_visual ? "\n" + Renderer::render_table(Renderer::create_visual_table(@grid)) + "\n" : nil
    end
  end

  def handle_file_input
    begin
      file = File.open(@filename)
    rescue StandardError
      puts "The file is either missing or in an invalid format. Please check the file and ensure all commands are in the proper format."
      exit
    end

    File.foreach(file) do |line|
      puts "\nCommand: #{line}"
      execute_command(line.upcase.split(" "))
    end
    file.close
  end

  ## The execute command function uses an error handling system to execute commands entered in
  def execute_command(command)
    begin
      is_valid?(command[0]) ? command_list[command[0]].call(command) : print("#{command.join(' ')} is an invalid command\n")
    rescue StandardError
      puts "Unable to process the command #{command.join}"
      exit
    end
  end
end
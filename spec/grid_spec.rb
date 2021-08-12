require_relative "../lib/Grid"
require_relative "../lib/Robot"


describe Robot do
	grid = Grid.new(rows: 5, cols: 5, enable_visual: false, input: :cli, filename: nil)

	it 'should create an empty 5x5 grid' do
		expect(grid.grid).to eq([[nil,nil,nil,nil,nil],[nil,nil,nil,nil,nil],[nil,nil,nil,nil,nil],[nil,nil,nil,nil,nil],[nil,nil,nil,nil,nil]])
	end

	it 'should check if a given command is valid' do
		expect(grid.is_valid?("PLACE")).to eq(true)
		expect(grid.is_valid?("MOVE")).to eq(true)
		expect(grid.is_valid?("DUMMY")).to eq(false)
	end

	it 'should check if PLACE arguments are valid' do
		expect(grid.place_args_valid?("1,2,NORTH")).to eq(true)
		expect(grid.place_args_valid?("2,1,SOUTH")).to eq(true)
		expect(grid.place_args_valid?("2,3,EAST")).to eq(true)
		expect(grid.place_args_valid?("4,4,WEST")).to eq(true)
		expect(grid.place_args_valid?("0,0,DUMMY")).to eq(false)
		expect(grid.place_args_valid?("A,B,SOUTH")).to eq(false)
	end

	it 'should check if the position the robot is being placed in is valid' do
		expect(grid.can_be_placed?(0,0)).to eq(true)
		expect(grid.can_be_placed?(1,2)).to eq(true)
		expect(grid.can_be_placed?(4,5)).to eq(false)
		expect(grid.can_be_placed?(6,4)).to eq(false)
	end

	it 'should disallow any command unless PLACE has been run' do
		expect { grid.execute_command(["MOVE"]) }.to output('ERROR: Robot has not been placed yet. Please place the robot first using the PLACE command.').to_stdout
	end

	it 'should place the robot at a given position' do
		grid.place(1,2,"NORTH")
		expect(grid.report).to eq([1,2,"NORTH"])
	end

	it 'should move from its current position in the given direction' do
		grid.move
		expect(grid.report).to eq([1,1,"NORTH"])
	end

	it 'should return an error when it is unable to move further in a particular direction' do
		grid.place(0,0,"WEST")
		expect { grid.move }.to output("ERROR: Unable to move any further").to_stdout
	end
end
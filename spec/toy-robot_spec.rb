require_relative "../lib/ToyRobot"

describe ToyRobot do
	toy_robot = ToyRobot.new(grid_size: 5)

	it 'should print an empty 5x5 board' do
		expect(toy_robot.board).to eq("
			┌─────┬─────┬─────┬─────┬─────┐
			│     │     │     │     │     │
			│     │     │     │     │     │
			│     │     │     │     │     │
			├─────┼─────┼─────┼─────┼─────┤
			│     │     │     │     │     │
			│     │     │     │     │     │
			│     │     │     │     │     │
			├─────┼─────┼─────┼─────┼─────┤
			│     │     │     │     │     │
			│     │     │     │     │     │
			│     │     │     │     │     │
			├─────┼─────┼─────┼─────┼─────┤
			│     │     │     │     │     │
			│     │     │     │     │     │
			│     │     │     │     │     │
			├─────┼─────┼─────┼─────┼─────┤
			│     │     │     │     │     │
			│     │     │     │     │     │
			│     │     │     │     │     │
			└─────┴─────┴─────┴─────┴─────┘
")
	end

	it 'should check if a given command is valid' do
		expect(toy_robot.is_valid?("PLACE")).to eq(true)
		expect(toy_robot.is_valid?("MOVE")).to eq(true)
		expect(toy_robot.is_valid?("DUMMY")).to eq(false)
	end

	it 'should check if PLACE arguments are valid' do
		expect(toy_robot.place_args_valid?("1,2,NORTH")).to eq(true)
		expect(toy_robot.place_args_valid?("2,1,SOUTH")).to eq(true)
		expect(toy_robot.place_args_valid?("2,3,EAST")).to eq(true)
		expect(toy_robot.place_args_valid?("4,4,WEST")).to eq(true)
		expect(toy_robot.place_args_valid?("0,0,DUMMY")).to eq(false)
		expect(toy_robot.place_args_valid?("A,B,SOUTH")).to eq(false)
	end

	it 'should check if the position the robot is being placed in is valid' do
		expect(toy_robot.can_be_placed?(0,0)).to eq(true)
		expect(toy_robot.can_be_placed?(1,2)).to eq(true)
		expect(toy_robot.can_be_placed?(4,5)).to eq(false)
		expect(toy_robot.can_be_placed?(6,4)).to eq(false)
	end

	it 'should disallow any command unless PLACE has been run' do
		expect { toy_robot.execute_command(["MOVE"]) }.to output('ERROR: Robot has not been placed yet. Please place the robot first using the PLACE command.').to_stdout
	end

	it 'should place the robot at a given position' do
		toy_robot.place(1,2,"NORTH")
		expect(toy_robot.report).to eq([1,2,0])
	end

	it 'should move from its current position in the given direction' do
		toy_robot.move
		expect(toy_robot.report).to eq([1,1,0])
	end

	it 'should return an error when it is unable to move further in a particular direction' do
		toy_robot.place(0,0,"WEST")
		expect { toy_robot.move }.to output("ERROR: Unable to move any further").to_stdout
	end
end
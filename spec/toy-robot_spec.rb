require_relative "../ToyRobot"

describe "ToyRobot" do
	toy_robot = ToyRobot.new(5)

	it 'should print an empty 5x5 board' do
		expect(toy_robot.board).to eq("
			┌───┬───┬───┬───┬───┐
			│   │   │   │   │   │
			├───┼───┼───┼───┼───┤
			│   │   │   │   │   │
			├───┼───┼───┼───┼───┤
			│   │   │   │   │   │
			├───┼───┼───┼───┼───┤
			│   │   │   │   │   │
			├───┼───┼───┼───┼───┤
			│   │   │   │   │   │
			└───┴───┴───┴───┴───┘")
	end

	it 'should check if a given command is valid' do
		expect(toy_robot.is_valid("PLACE")).to eq(true)
		expect(toy_robot.is_valid("MOVE")).to eq(true)
		expect(toy_robot.is_valid("DUMMY")).to eq(false)
	end

	it 'should check if PLACE arguments are valid' do
		expect(toy_robot.is_valid("PLACE")).to eq(true)
		expect(toy_robot.is_valid("MOVE")).to eq(true)
		expect(toy_robot.is_valid("DUMMY")).to eq(false)
	end


end
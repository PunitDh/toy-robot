require_relative "../lib/Robot"

describe Robot do
	robot = Robot.new(x: 4, y: 3, f: "SOUTH")

	it 'should initialize the robot with given values' do
		expect(robot.x).to eq(4)
		expect(robot.y).to eq(3)
		expect(robot.f).to eq("SOUTH")
	end
end
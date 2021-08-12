require_relative "../lib/helpers/commands"
require_relative "../lib/Grid"
require_relative "../lib/Robot"

describe Commands do
	include Commands

	grid = Grid.new(rows: 5, cols: 5, enable_visual: false, input: :cli, filename: nil)
	
	it 'should correctly extract all ARGV commands' do
		expect(Commands::check_argvs(["grid=5,5", "visual", "file=filename.json"])).to eq({ rows: 5, cols: 5, visual: true, input: :file, filename: "filename.json" })
		expect(Commands::check_argvs(["grid=5,5"])).to eq({ rows: 5, cols: 5, visual: false, input: :cli, filename: nil })
		expect(Commands::check_argvs(["file=test.txt"])).to eq({ rows: 5, cols: 5, visual: false, input: :file, filename: "test.txt" })
	end

	it 'should return all valid directions as a hash' do
		expect(directions).to be_kind_of(Hash)
		expect(directions["NORTH"]).to eq([-1,0])
	end

	it 'should return all valid CLI arguments' do
		expect(Commands::argvs.length).to eq(3)
	end

	it 'should return a list of all valid commands as a hash' do
		expect(command_list).to be_kind_of(Hash)
	end

	it 'should check if a given command is valid' do
		expect(is_valid?("PLACE")).to eq(true)
		expect(is_valid?("MOVE")).to eq(true)
		expect(is_valid?("DUMMY")).to eq(false)
	end
	
	it 'should correctly check if PLACE arguments are valid' do
		expect(place_args_valid?(nil)).to be_falsey
		expect(place_args_valid?(nil)).to be_falsey
	end

	it 'should correctly place robot in a given location' do
		expect(place_robot([["PLACE", "1,2,EAST"]])).to eq(true)
	end

	it 'should correctly deconstruct PLACE arguments' do
		expect(place_args_deconstruct("1,2,NORTH")).to eq(["1","2","NORTH"])
	end

end
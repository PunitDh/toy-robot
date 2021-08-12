require_relative "../lib/helpers/commands"

describe Helper do
	it 'should correctly extract all ARGV commands' do
		expect(Commands::check_argvs(["grid=5,5", "visual", "file=filename.json"])).to eq({ rows: 5, cols: 5, visual: true, input: :file, filename: "filename.json" })
	end
end
require_relative "../lib/helpers/helper"

describe Helper do
	it 'should correctly evaluate is_i? function' do
		expect(Helper::is_i?("1")).to eq(true)
		expect(Helper::is_i?("0")).to eq(true)
		expect(Helper::is_i?("-01")).to eq(true)
		expect(Helper::is_i?("12342")).to eq(true)
		expect(Helper::is_i?("test")).to eq(false)
	end

	it 'should correctly evaluate whether a grid size is valid' do
		expect(Helper::is_valid_grid_size?("5")).to eq(true)
		expect(Helper::is_valid_grid_size?(5)).to eq(false)
		expect(Helper::is_valid_grid_size?("-5")).to eq(false)
		expect(Helper::is_valid_grid_size?("0")).to eq(false)
	end
end
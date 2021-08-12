module Renderer
  
  ## The create_visual_table takes in the grid as an argument and creates a table using the TTY-table gem and returns the table
  def self.create_visual_table(grid)
    table = TTY::Table.new
    grid.map.with_index do |row, i|
      display_row = []
      row = row.map.with_index { |col, j| display_row << (col.nil? ? "  " : "🤖") }
      table << display_row
    end
    return table
  end

  ## The render_table method takes in the table as an argument and returns the rendered version of the table. It uses the TTY-table gem
  def self.render_table(table)
    renderer = TTY::Table::Renderer::Unicode.new(table)
    renderer.border.separator = :each_row
    return renderer.render
  end

end
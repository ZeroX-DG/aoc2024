Code.require_file("../helpers/grid.ex")

defmodule Day4 do
  def part1 do
    grid = Grid.read("input.txt")

    Grid.foreach(grid, ["X", "S"], fn row_idx, col_idx ->
      [
        Grid.slice_x(grid, row_idx, col_idx, 4),
        Grid.slice_y(grid, row_idx, col_idx, 4),
        Grid.slice_xy_left_right(grid, row_idx, col_idx, 4),
        Grid.slice_xy_right_left(grid, row_idx, col_idx, 4)
      ]
      |> Enum.filter(fn slice ->
        case slice do
          ["X", "M", "A", "S"] -> true
          ["S", "A", "M", "X"] -> true
          _ -> false
        end
      end)
      |> length
    end)
    |> Enum.sum()
    |> IO.inspect()
  end
end

Day4.part1()

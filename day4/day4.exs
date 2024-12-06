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

  def part2 do
    grid = Grid.read("input.txt")

    Grid.foreach(grid, ["A"], fn row_idx, col_idx ->
      [
        Grid.slice_xy_reverse_right_left(grid, row_idx, col_idx, 2),
        Grid.slice_xy_reverse_left_right(grid, row_idx, col_idx, 2),
        Grid.slice_xy_left_right(grid, row_idx, col_idx, 2),
        Grid.slice_xy_right_left(grid, row_idx, col_idx, 2)
      ]
    end)
    |> Enum.filter(fn x ->
      case x do
        [["A", "M"], ["A", "S"], ["A", "S"], ["A", "M"]] -> true
        [["A", "S"], ["A", "M"], ["A", "M"], ["A", "S"]] -> true
        [["A", "M"], ["A", "M"], ["A", "S"], ["A", "S"]] -> true
        [["A", "S"], ["A", "S"], ["A", "M"], ["A", "M"]] -> true
        _ -> false
      end
    end)
    |> length
    |> IO.inspect()
  end
end

Day4.part1()
Day4.part2()

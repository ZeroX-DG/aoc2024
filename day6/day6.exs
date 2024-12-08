Code.require_file("../helpers/grid.ex")

defmodule Day6 do
  def step_until_done(grid, loop_count \\ 0) do
    if Grid.contains(grid, ["^", ">", "v", "<"]) do
      new_grid = step(grid)
      is_loop = Grid.count(grid, "X") == Grid.count(new_grid, "X")

      if is_loop and loop_count > 5 do
        { grid, true }
      else
        step_until_done(new_grid, if is_loop do loop_count + 1 else loop_count end)
      end
    else
      { grid, false }
    end
  end

  def step(grid) do
    new_grid =
      Grid.foreach(grid, ["^", ">", "v", "<"], fn start_y, start_x ->
        direction = Grid.cell(grid, start_y, start_x)

        case direction do
          "^" ->
            {new_grid, last_y, last_x, oob} =
              Grid.fill_up(grid, start_y, start_x, "X", fn cell -> cell != "#" and cell != "O" end)

            if !oob do
              Grid.fill(new_grid, last_y, last_x, ">")
            else
              new_grid
            end

          ">" ->
            {new_grid, last_y, last_x, oob} =
              Grid.fill_right(grid, start_y, start_x, "X", fn cell -> cell != "#" and cell != "O" end)

            if !oob do
              Grid.fill(new_grid, last_y, last_x, "v")
            else
              new_grid
            end

          "v" ->
            {new_grid, last_y, last_x, oob} =
              Grid.fill_down(grid, start_y, start_x, "X", fn cell -> cell != "#" and cell != "O" end)

            if !oob do
              Grid.fill(new_grid, last_y, last_x, "<")
            else
              new_grid
            end

          "<" ->
            {new_grid, last_y, last_x, oob} =
              Grid.fill_left(grid, start_y, start_x, "X", fn cell -> cell != "#" and cell != "O" end)

            if !oob do
              Grid.fill(new_grid, last_y, last_x, "^")
            else
              new_grid
            end
        end
      end)

    if length(new_grid) == 0 do
      grid
    else
      new_grid |> Enum.at(0)
    end
  end

  def part1 do
    grid = Grid.read("input.txt")

    {new_grid, _} = step_until_done(grid)
    IO.inspect(new_grid |> Grid.count("X"))
  end

  def part2 do
    grid = Grid.read("input.txt")
    {walked_grid, _} = step_until_done(grid)

    Grid.foreach(walked_grid, ["X"], fn row, col ->
      new_grid = Grid.fill(grid, row, col, "O")
      {_, is_loop} = step_until_done(new_grid)
      is_loop
    end)
    |> Enum.filter(fn is_loop -> is_loop end)
    |> Enum.count()
    |> IO.inspect
  end
end

Day6.part1()
Day6.part2()

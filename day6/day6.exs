Code.require_file("../helpers/grid.ex")

defmodule Day6 do
  def step_until_done(grid) do
    new_grid = step(grid)

    if Grid.contains(grid, ["^", ">", "v", "<"]) do
      step_until_done(new_grid)
    else
      new_grid
    end
  end

  def step(grid) do
    new_grid =
      Grid.foreach(grid, ["^", ">", "v", "<"], fn start_y, start_x ->
        direction = Grid.cell(grid, start_y, start_x)

        case direction do
          "^" ->
            {new_grid, last_y, last_x, oob} =
              Grid.fill_up(grid, start_y, start_x, "X", fn cell -> cell != "#" end)

            if !oob do
              Grid.fill(new_grid, last_y, last_x, ">")
            else
              new_grid
            end

          ">" ->
            {new_grid, last_y, last_x, oob} =
              Grid.fill_right(grid, start_y, start_x, "X", fn cell -> cell != "#" end)

            if !oob do
              Grid.fill(new_grid, last_y, last_x, "v")
            else
              new_grid
            end

          "v" ->
            {new_grid, last_y, last_x, oob} =
              Grid.fill_down(grid, start_y, start_x, "X", fn cell -> cell != "#" end)

            if !oob do
              Grid.fill(new_grid, last_y, last_x, "<")
            else
              new_grid
            end

          "<" ->
            {new_grid, last_y, last_x, oob} =
              Grid.fill_left(grid, start_y, start_x, "X", fn cell -> cell != "#" end)

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

    new_grid = step_until_done(grid)
    IO.inspect(new_grid |> Grid.count("X"))
  end
end

Day6.part1()

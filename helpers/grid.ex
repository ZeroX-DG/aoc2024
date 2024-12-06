defmodule Grid do
  def read(file_path) do
    file_path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split("", trim: true)
    end)
  end

  def contains(grid, chars) do
    Enum.any?(grid, fn row ->
      Enum.any?(row, fn col -> col in chars end)
    end)
  end

  def cell(grid, row, col) do
    Enum.at(grid, row) |> Enum.at(col)
  end

  def fill(grid, row, col, value) do
    List.replace_at(grid, row, List.replace_at(Enum.at(grid, row), col, value))
  end

  def fill_up(grid, row, col, value, predicate) do
    if row < 0 or !predicate.(Grid.cell(grid, row, col)) do
      {grid, row + 1, col, row < 0}
    else
      Grid.fill(grid, row, col, value)
      |> fill_up(row - 1, col, value, predicate)
    end
  end

  def fill_down(grid, row, col, value, predicate) do
    if row > length(grid) - 1 or !predicate.(Grid.cell(grid, row, col)) do
      {grid, row - 1, col, row > length(grid) - 1}
    else
      Grid.fill(grid, row, col, value)
      |> fill_down(row + 1, col, value, predicate)
    end
  end

  def fill_right([head | _] = grid, row, col, value, predicate) do
    if col > length(head) - 1 or !predicate.(Grid.cell(grid, row, col)) do
      {grid, row, col - 1, col > length(head) - 1}
    else
      Grid.fill(grid, row, col, value)
      |> fill_right(row, col + 1, value, predicate)
    end
  end

  def fill_left(grid, row, col, value, predicate) do
    if col < 0 or !predicate.(Grid.cell(grid, row, col)) do
      {grid, row, col + 1, col < 0}
    else
      Grid.fill(grid, row, col, value)
      |> fill_left(row, col - 1, value, predicate)
    end
  end

  def count(grid, char) do
    Enum.reduce(grid, 0, fn row, acc ->
      acc + Enum.count(row, fn col -> col == char end)
    end)
  end

  def foreach(grid, chars, callback) do
    for {row, row_idx} <- Enum.with_index(grid),
        {cell, col_idx} <- Enum.with_index(row),
        Enum.member?(chars, cell) do
      callback.(row_idx, col_idx)
    end
  end

  def slice_x(grid, row_idx, col_idx, len) do
    cond do
      col_idx + len > length(Enum.at(grid, row_idx)) -> []
      true -> Enum.map(0..(len - 1), fn i -> Enum.at(grid, row_idx) |> Enum.at(col_idx + i) end)
    end
  end

  def slice_y(grid, row_idx, col_idx, len) do
    cond do
      row_idx + len > length(grid) -> []
      true -> Enum.map(0..(len - 1), fn i -> Enum.at(grid, row_idx + i) |> Enum.at(col_idx) end)
    end
  end

  def slice_xy_left_right(grid, row_idx, col_idx, len) do
    cond do
      col_idx + len > length(Enum.at(grid, row_idx)) ->
        []

      row_idx + len > length(grid) ->
        []

      true ->
        Enum.map(0..(len - 1), fn i -> Enum.at(grid, row_idx + i) |> Enum.at(col_idx + i) end)
    end
  end

  def slice_xy_right_left(grid, row_idx, col_idx, len) do
    cond do
      row_idx + len > length(grid) ->
        []

      col_idx - len + 1 < 0 ->
        []

      true ->
        Enum.map(0..(len - 1), fn i -> Enum.at(grid, row_idx + i) |> Enum.at(col_idx - i) end)
    end
  end

  def slice_xy_reverse_right_left(grid, row_idx, col_idx, len) do
    cond do
      row_idx - len + 1 < 0 ->
        []

      col_idx - len + 1 < 0 ->
        []

      true ->
        Enum.map(0..(len - 1), fn i -> Enum.at(grid, row_idx - i) |> Enum.at(col_idx - i) end)
    end
  end

  def slice_xy_reverse_left_right(grid, row_idx, col_idx, len) do
    cond do
      row_idx - len + 1 < 0 ->
        []

      col_idx + len > length(Enum.at(grid, row_idx)) ->
        []

      true ->
        Enum.map(0..(len - 1), fn i -> Enum.at(grid, row_idx - i) |> Enum.at(col_idx + i) end)
    end
  end
end

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

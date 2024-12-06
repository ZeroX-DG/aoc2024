defmodule Day5 do
  def verify_update(rules, update) do
    case update do
      [] ->
        true

      [_] ->
        true

      [x, y | rest] ->
        found_rule =
          Enum.find(rules, fn rule -> Enum.at(rule, 0) == x and Enum.at(rule, 1) == y end)

        if found_rule != nil do
          verify_update(rules, [y | rest])
        else
          false
        end
    end
  end

  def part1 do
    file_path = "input.txt"

    lines =
      file_path
      |> File.read!()
      |> String.split("\n")

    rules =
      Enum.take_while(lines, fn line -> String.length(line) != 0 end)
      |> Enum.map(fn line -> String.split(line, "|") end)

    updates =
      Enum.drop_while(lines, fn line -> String.length(line) != 0 end)
      |> Enum.filter(fn line -> String.length(line) > 0 end)
      |> Enum.map(fn line -> String.split(line, ",") end)

    correct_updates =
      Enum.filter(updates, fn update ->
        verify_update(rules, update)
      end)

    mid_page_sum =
      Enum.map(correct_updates, fn pages ->
        String.to_integer(Enum.at(pages, div(length(pages), 2)))
      end)
      |> Enum.sum()

    IO.inspect(mid_page_sum)
  end
end

Day5.part1()

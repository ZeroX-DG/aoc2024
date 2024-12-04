defmodule Day2 do
  def verify_safety([], _), do: true
  def verify_safety([_], _), do: true
  def verify_safety([first, second | rest], previous_offset) do
    offset = String.to_integer(first) - String.to_integer(second)

    cond do
      # When the offset difference is too large then it's not safe
      abs(offset) > 3 or abs(offset) < 1 -> false
      # When the offset is opposite to the direction then it's not safe
      (offset > 0 and previous_offset < 0) or (offset < 0 and previous_offset > 0) -> false
      # Otherwise we keep checking the next pairs
      true -> verify_safety([second | rest], offset)
    end
  end

  def verify_safety_dampened(list, previous_offset) do
    case list do
      [first, second, third | rest] ->
        offset1 = String.to_integer(first) - String.to_integer(second)
        offset2 = String.to_integer(second) - String.to_integer(third)

        # retry by skiping first second or third from the list
        retry = fn ->
          verify_safety([first, third | rest], previous_offset) or
          verify_safety([second, third | rest], previous_offset) or
          verify_safety([first, second | rest], previous_offset)
        end

        cond do
          # When the offset difference is too large then it's not safe
          abs(offset1) > 3 or abs(offset1) < 1 or abs(offset2) > 3 or abs(offset2) < 1 -> retry.()

          # When the offset is opposite to the direction then it's not safe
          (offset1 > 0 and previous_offset < 0) or
            (offset1 < 0 and previous_offset > 0) or
            (offset2 > 0 and offset1 < 0) or
            (offset2 < 0 and offset1 > 0) -> retry.()

          # Otherwise we keep checking the next pairs
          true -> verify_safety_dampened([second, third | rest], offset1)
        end
      [_, _ | _] -> verify_safety(list, previous_offset)
      _ -> true
    end
  end
  
  def part1 do
    result =
      File.stream!("input.txt")
      |> Enum.filter(fn line ->
        String.split(line, ~r/\s+|,/, trim: true)
        |> Day2.verify_safety(0)
      end)
      |> length

    IO.puts("Part 1 result: #{result}")
  end

  def part2 do
    result =
      File.stream!("input.txt")
      |> Enum.filter(fn line ->
        String.split(line, ~r/\s+|,/, trim: true)
        |> Day2.verify_safety_dampened(0)
      end)
      |> length

    IO.puts("Part 2 result: #{result}")
  end
end

Day2.part1
Day2.part2

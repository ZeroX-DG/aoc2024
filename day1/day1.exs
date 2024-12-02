defmodule Day1 do
  def part1 do
    {listA, listB} =
      File.stream!("input.txt")
      |> Enum.reduce({[], []}, fn line, {acc1, acc2} ->
        [locationA, locationB] = String.split(line, ~r/\s+|,/, trim: true)
        |> Enum.map(&String.to_integer/1)

        {[locationA | acc1], [locationB | acc2]}
      end)
      |> (fn {listA, listB} -> {Enum.sort(listA), Enum.sort(listB)} end).()

    result = Enum.zip(listA, listB)
    |> Enum.map(fn {locationA, locationB} -> abs(locationA - locationB) end)
    |> Enum.sum

    IO.puts("Part 1 result: #{result}")
  end

  def part2 do
    {listA, listB} =
      File.stream!("input.txt")
      |> Enum.reduce({[], []}, fn line, {acc1, acc2} ->
        [locationA, locationB] = String.split(line, ~r/\s+|,/, trim: true)
        |> Enum.map(&String.to_integer/1)

        {[locationA | acc1], [locationB | acc2]}
      end)

    result = Enum.map(listA, fn locationA ->
      appearanceCount = length(Enum.filter(listB, fn locationB -> locationB == locationA end))
      locationA * appearanceCount
    end)
    |> Enum.sum

    IO.puts("Part 2 result: #{result}")
  end
end

Day1.part1
Day1.part2

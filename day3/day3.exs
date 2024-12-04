defmodule Day3 do
  def parse_number(characters) do
    number = Enum.take_while(characters, fn char -> char in ?0..?9 end)
    |> List.to_string
    |> String.to_integer
    remaining = Enum.drop_while(characters, fn char -> char in ?0..?9 end)

    {number, remaining}
  end

  def parse(characters, enable, consider_do_dont) do
    case characters do
      [?m, ?u, ?l, ?( | rest] when enable -> 
        try do
          # parse a number
          {a, remaining} = parse_number(rest)

          # parse a comma
          [?, | rest] = remaining

          # parse second number
          {b, remaining} = parse_number(rest)

          # parse a closing bracket
          [?) | rest] = remaining

          parse(rest, enable, consider_do_dont) + a * b
        rescue
          _ in MatchError -> parse(rest, enable, consider_do_dont)
        end

      # do
      [?d, ?o, ?(, ?) | rest] when consider_do_dont -> parse(rest, true, true)

      # don't
      [?d, ?o, ?n, ?', ?t, ?(, ?) | rest] when consider_do_dont -> parse(rest, false, true)

      [_ | rest] -> parse(rest, enable, consider_do_dont)
      _ -> 0
    end
  end

  def part1 do
    {:ok, contents} = File.read("input.txt")
    IO.puts("part 1 result: #{parse(String.to_charlist(contents), true, false)}")
  end

  def part2 do
    {:ok, contents} = File.read("input.txt")
    IO.puts("part 2 result: #{parse(String.to_charlist(contents), true, true)}")
  end
end

Day3.part1
Day3.part2

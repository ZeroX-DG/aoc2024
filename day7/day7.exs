defmodule Day7 do
  defp build_equations([operand], _, acc), do: [Enum.reverse([operand | acc])]

  defp build_equations([operand | rest], operators, acc) do
    operators
      |> Enum.flat_map(fn operator ->
        build_equations(rest, operators, [operator, operand | acc])
      end)
  end

  def eval_equation([a]), do: a

  def eval_equation([a, operator, b | rest]) do
    case operator do
      :+ -> eval_equation([a + b | rest])
      :* -> eval_equation([a * b | rest])
    end
  end

  def verify_equation(test_value, equation) do
    build_equations(equation, [:+, :*], [])
    |> Enum.map(&eval_equation/1)
    |> Enum.any?(fn result -> result == test_value end)
  end

  def part1 do
    file_path = "input.txt"

    lines =
      file_path
      |> File.read!()
      |> String.split("\n", trim: true)

    equations = lines
      |> Enum.map(fn line ->
        [test_value, equation] = String.split(line, ":")
        { String.to_integer(test_value), String.split(equation, " ", trim: true) |> Enum.map(&String.to_integer/1) }
      end)

    equations
      |> Enum.filter(fn {test_value, equation} -> verify_equation(test_value, equation) end)
      |> Enum.reduce(0, fn {test_value, _}, acc -> acc + test_value end)
      |> IO.inspect 
  end
end

Day7.part1

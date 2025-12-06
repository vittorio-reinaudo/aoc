defmodule AdventOfCode.Day6 do
  ################
  #### PART 1 ####
  ################

  def t1 do
    File.read!("lib/advent_of_code/aoc/day6_input.txt")
    |> String.split("\n")
    |> Enum.map(fn row ->
      String.split(row, " ")
      |> Stream.map(&String.trim/1)
      |> Stream.reject(&(&1 == ""))
      |> Enum.to_list()
    end)
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&extract_operator/1)
    |> Enum.reduce(0, fn {op, numbers}, acc -> resolve(op, numbers, acc) end)
  end

  defp extract_operator(row) do
    {numbers, [operator]} = Enum.split(row, -1)
    {operator, numbers}
  end

  ################
  #### PART 2 ####
  ################

  def t2 do
    File.read!("lib/advent_of_code/aoc/day6_input.txt")
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
    |> List.zip()
    |> Stream.map(&Tuple.to_list/1)
    |> Stream.chunk_by(fn r -> Enum.all?(r, &(&1 == " ")) end)
    |> Stream.reject(fn list -> Enum.at(list, 0) |> Enum.all?(&(&1 == " ")) end)
    |> Stream.map(&merge_charlists/1)
    |> Enum.reduce(0, fn {op, numbers}, acc -> resolve(op, numbers, acc) end)
  end

  defp merge_charlists(charlists) do
    [op] = Enum.at(charlists, 0) |> Enum.split(-1) |> elem(1)

    numbers =
      Enum.map(charlists, fn n ->
        Enum.split(n, -1) |> elem(0) |> Enum.reject(&(&1 == " ")) |> Enum.join()
      end)

    {op, numbers}
  end

  ##########################
  #### COMMON FUNCTIONS ####
  ##########################

  defp resolve(op, numbers, acc) do
    acc + Enum.reduce(numbers, 0, &elaborate_number(&2, op, String.to_integer(&1)))
  end

  defp elaborate_number(acc, "+", n), do: acc + n
  defp elaborate_number(0, "*", n), do: n
  defp elaborate_number(acc, "*", n), do: acc * n
end

defmodule AdventOfCode.Day3 do
  def t do
    # "987654321111111\n811111111111119\n234234234234278\n818181911112111"
    r1 =
      File.read!("lib/advent_of_code/aoc/day3_input.txt")
      |> String.split("\n")
      |> Enum.map(fn r ->
        l =
          String.trim(r)
          |> String.split("")
          |> Enum.reject(&(&1 == ""))

        {h, i} = slice_and_find_max(l, 0, String.length(r) - 1)
        {t, _i} = slice_and_find_max(l, i + 1, String.length(r))

        "#{h}#{t}"
      end)
      |> Enum.map(&String.to_integer/1)
      |> Enum.sum()

    r2 =
      File.read!("lib/advent_of_code/aoc/day3_input.txt")
      |> String.split("\n")
      |> Enum.map(fn r ->
        l =
          String.trim(r)
          |> String.split("")
          |> Enum.reject(&(&1 == ""))

        find_recurively(l, String.length(r), 12)
        |> Enum.join("")
        |> String.to_integer()
      end)
      |> Enum.sum()

    {r1, r2}
  end

  def find_recurively(l, total_length, depth, step \\ 0, start \\ 0, acc \\ [])

  def find_recurively(_l, _total_length, 0, _step, _start, acc), do: acc

  def find_recurively(l, total_length, depth, step, start, acc) do
    {x, i} = slice_and_find_max(l, start, total_length - depth + 1)
    find_recurively(l, total_length, depth - 1, step + 1, i + 1, acc ++ [x])
  end

  defp slice_and_find_max(l, s, e) do
    l
    |> Enum.slice(s, e - s)
    |> then(fn sub ->
      sub
      |> Enum.map(&String.to_integer/1)
      |> Enum.max()
      |> then(fn x ->
        {x, Enum.find_index(sub, &(&1 == Integer.to_string(x))) + s}
      end)
    end)
  end
end

defmodule AdventOfCode.Day2 do
  def t do
    r1 =
      File.read!("lib/advent_of_code/day2_input.txt")
      |> String.split(",")
      |> Enum.flat_map(fn r ->
        [s, e] = String.split(r, "-")
        String.to_integer(s)..String.to_integer(e)
      end)
      |> Enum.filter(&is_invalid?/1)
      |> Enum.sum()

    r2 =
      File.read!("lib/advent_of_code/day2_input.txt")
      |> String.split(",")
      |> Enum.flat_map(fn r ->
        [s, e] = String.split(r, "-")
        String.to_integer(s)..String.to_integer(e)
      end)
      |> Enum.filter(&is_invalid2?/1)
      |> Enum.sum()

    {r1, r2}
  end

  defp is_invalid?(integer) do
    string = to_string(integer)
    len = String.length(string)

    String.split_at(string, div(len, 2))
    |> check_sequence()
  end

  defp check_sequence({h, t}) when h == t, do: true
  defp check_sequence(_), do: false

  defp is_invalid2?(integer) do
    string = to_string(integer)
    len = String.length(string)

    if len > 1 do
      Enum.any?(1..div(len, 2), fn i ->
        Enum.chunk_every(String.to_charlist(string), i)
        |> Enum.uniq()
        |> length()
        |> then(&(&1 == 1))
      end)
    else
      false
    end
  end

  ##################################################################################################################################
  ##################################################################################################################################
  ##################################################################################################################################
  ##################################################################################################################################
  ##################################################################################################################################
  ##################################################################################################################################

  def test_get_next_position_and_count do
    "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"
    |> String.split(",")
    |> Enum.flat_map(fn r ->
      [s, e] = String.split(r, "-")
      String.to_integer(s)..String.to_integer(e)
    end)
    |> Enum.filter(&is_invalid2?/1)
    |> Enum.sum()
    |> IO.inspect()

    result = 4_174_379_265
  end
end

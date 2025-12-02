defmodule AdventOfCode.Day1 do
  def t do
    rotations =
      File.read!("lib/advent_of_code/day1_input.txt")
      |> String.split("\n")

    # PART 1
    {_final, count_exact_zero} =
      Enum.reduce(rotations, {50, 0}, fn rotation, {curr_position, zero_count} ->
        pos = get_next_position(curr_position, rotation)
        zero_count = if pos == 0, do: zero_count + 1, else: zero_count
        {pos, zero_count}
      end)

    # PART 2
    {_final, count_zero_pass} =
      Enum.reduce(rotations, {50, 0}, fn rotation, {curr_position, zero_count} ->
        {count, pos} = get_next_position_and_count(curr_position, rotation)
        {pos, zero_count + count}
      end)

    %{count_exact_zero: count_exact_zero, count_zero_pass: count_zero_pass}
  end

  def get_next_position(pos, rotation) do
    get_number_from_rotation(rotation)
    |> Kernel.+(pos)
    |> parse_negative()
    |> parse_over_limit()
  end

  def get_next_position_and_count(pos, rotation) do
    move =
      get_number_from_rotation(rotation)

    new_position =
      (pos + move)
      |> parse_negative()
      |> parse_over_limit()

    c =
      cond do
        move > 0 ->
          div(pos + move, 100) |> abs()

        move < 0 ->
          n = div(pos - 100 + move, 100) |> abs()

          if pos == 0 and n > 0 do
            n - 1
          else
            n
          end

        true ->
          0
      end

    {c, new_position}
  end

  def parse_negative(n) when n < 0, do: 100 + rem(n, 100)
  def parse_negative(n), do: n
  def parse_over_limit(n) when n > 99, do: rem(n, 100)
  def parse_over_limit(n), do: n

  def parse_and_count_negative(n) when n < 0, do: 1
  def parse_and_count_negative(_), do: 0

  def parse_and_count_over_limit(0), do: {1, 0}
  def parse_and_count_over_limit(n) when n > 99, do: {abs(trunc(div(n, 100))), rem(n, 100)}
  def parse_and_count_over_limit(n), do: {0, n}

  def get_number_from_rotation("L" <> string), do: String.to_integer(string) * -1
  def get_number_from_rotation("R" <> string), do: String.to_integer(string)

  ##################################################################################################################################
  ##################################################################################################################################
  ##################################################################################################################################
  ##################################################################################################################################
  ##################################################################################################################################
  ##################################################################################################################################
  def test_get_next_position_and_count do
    test_cases = [
      {90, "R220", {3, 10}},
      {20, "L725", {8, 95}},
      {79, "L79", {1, 0}},
      {0, "L1", {0, 99}},
      {30, "L10", {0, 20}},
      {80, "R10", {0, 90}},
      {90, "R10", {1, 0}},
      {10, "L10", {1, 0}},
      {10, "R10", {0, 20}},
      {99, "L98", {0, 1}},
      {99, "R1", {1, 0}},
      {0, "R210", {2, 10}},
      {0, "R200", {2, 0}},
      {0, "L210", {2, 90}},
      {0, "L200", {2, 0}}
    ]

    results =
      Enum.map(test_cases, fn {pos, rotation, expected} ->
        result = get_next_position_and_count(pos, rotation)
        passed = result == expected

        %{
          pos: pos,
          rotation: rotation,
          result: {result, expected},
          passed: passed
        }
      end)

    all_passed = Enum.all?(results, & &1.passed)

    %{
      results: results,
      all_passed: all_passed,
      summary: "#{Enum.count(results, & &1.passed)}/#{length(results)} tests passed"
    }
  end
end

defmodule AdventOfCode.Day4 do
  def t do
    # "987654321111111\n811111111111119\n234234234234278\n818181911112111"
    matrix =
      File.read!("lib/advent_of_code/aoc/day4_input.txt")
      |> String.split("\n")
      |> Enum.map(&String.graphemes/1)


    # Enum.flat_map(0..(length(matrix) - 1), fn r ->
    #   Enum.map(0..(length(Enum.at(matrix, 0)) - 1), fn c ->
    #     if Enum.at(matrix, r) |> Enum.at(c) |> is_roller() do
    #       is_movable(matrix, r, c)
    #     else
    #       false
    #     end
    #   end)
    # end)
    # |> Enum.filter(& &1)
    # |> Enum.count()

    initial = count_roller(matrix)
    final = recursive_remove(matrix)
    initial - final
  end

  def recursive_remove(matrix) do
    count = count_roller(matrix)

    new_matrix =
      Enum.map(0..(length(matrix) - 1), fn r ->
        Enum.map(0..(length(Enum.at(matrix, 0)) - 1), fn c ->
          if Enum.at(matrix, r) |> Enum.at(c) |> is_roller() do
            if is_movable(matrix, r, c) do
              "."
            else
              "@"
            end
          else
            "."
          end
        end)
      end)

    final_count = count_roller(new_matrix)

    if final_count == count do
      count
    else
      recursive_remove(new_matrix)
    end
  end

  defp count_roller(matrix) do
    Enum.flat_map(matrix, & &1)
    |> Enum.filter(&is_roller(&1))
    |> Enum.count()
  end

  @pos_to_check [
    {1, 1},
    {1, 0},
    {1, -1},
    {0, 1},
    {0, -1},
    {-1, 0},
    {-1, 1},
    {-1, -1}
  ]

  defp is_movable(matrix, r, c) do
    Enum.filter(@pos_to_check, fn {r_shift, c_shift} ->
      there_is_roller(matrix, r + r_shift, c + c_shift)
    end)
    |> length()
    |> Kernel.<(4)
  end

  defp there_is_roller(matrix, row, column) do
    if(is_out_of_boundary(matrix, row, column),
      do: false,
      else: is_roller(Enum.at(matrix, row) |> Enum.at(column))
    )
  end

  defp is_roller("@"), do: true
  defp is_roller(_), do: false

  defp is_out_of_boundary(matrix, row, column) do
    row_len = length(matrix)
    col_len = length(Enum.at(matrix, 0))

    cond do
      row >= row_len or row < 0 -> true
      column >= col_len or column < 0 -> true
      true -> false
    end
  end
end

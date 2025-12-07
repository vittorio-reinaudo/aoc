defmodule AdventOfCode.Day7 do
  ################
  #### PART 1 ####
  ################

  def t1 do
    {starting_col, splitter_map} = get_initial_structure()

    check_next_splitter(starting_col, 0, splitter_map)
    |> Map.values()
    |> Enum.flat_map(& &1)
    |> Enum.filter(fn {_, check} -> check end)
    |> length()
  end

  defp check_next_splitter(column, depth, splitter_map) do
    if valid_column?(column, splitter_map) do
      hitted_splitter =
        Map.get(splitter_map, column)
        |> Enum.filter(fn {pos, _checked} -> pos > depth end)
        |> Enum.sort()
        |> Enum.at(0)

      case hitted_splitter do
        nil ->
          splitter_map

        {_pos, true} ->
          splitter_map

        {pos, false} ->
          new_map = check_splitter(column, pos, splitter_map)
          new_map = check_next_splitter(column - 1, pos, new_map)
          check_next_splitter(column + 1, pos, new_map)
      end
    else
      splitter_map
    end
  end

  def check_splitter(col, depth, splitter_map) do
    list = Map.get(splitter_map, col)

    i = Enum.find_index(list, &(&1 == {depth, false}))

    new_list = List.replace_at(list, i, {depth, true})
    Map.put(splitter_map, col, new_list)
  end

  def valid_column?(col, splitter_map) do
    case Map.get(splitter_map, col) do
      nil -> false
      l when is_list(l) -> true
      _ -> false
    end
  end

  defp get_initial_structure() do
    [h | t] =
      File.read!("lib/advent_of_code/aoc/day7_input.txt")
      |> String.split("\n")

    starting_column = String.graphemes(h) |> Enum.find_index(&(&1 == "S"))

    all =
      Enum.map(t, &String.graphemes/1)
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {arr, col}, acc ->
        positions =
          Enum.with_index(arr)
          |> Enum.reduce([], fn {el, row}, acc2 ->
            case el do
              "^" -> [{row, false} | acc2]
              "." -> acc2
            end
          end)

        Map.put(acc, col, positions)
      end)

    {starting_column, all}
  end

  ################
  #### PART 2 ####
  ################
  def t2 do
    {starting_col, splitter_map, last_splitter_depth} = get_initial_structure2()

    first_hitted_pos = find_next(starting_col, 0, splitter_map)
    initial_map = increment_splitter(splitter_map, first_hitted_pos, 1)

    r =
      Enum.reduce(0..last_splitter_depth, initial_map, fn depth, map_acc ->
        find_depth_splitters_pos(map_acc, depth)
        |> Enum.reduce(map_acc, fn pos, flying_matrix ->
          increment_next_splitters(pos, flying_matrix)
        end)
      end)
      find_depth_splitters_pos(r, last_splitter_depth)
      |> Enum.map(& Map.get(r, &1))
      |> Enum.sum()
  end

  defp find_depth_splitters_pos(matrix, depth) do
    Map.keys(matrix)
    |> Enum.filter(fn {r, _c} -> r == depth end)
  end

  defp increment_next_splitters({row, col} = pos, map) do
    increment = Map.get(map, pos)
    left_pos = find_next(col - 1, row, map)
    right_pos = find_next(col + 1, row, map)

    new_map = increment_splitter(map, left_pos, increment) #|> print_matrix()
    increment_splitter(new_map, right_pos, increment) #|> print_matrix()
  end

  defp increment_splitter(map, nil, _), do: map

  defp increment_splitter(map, pos, increment), do:
    Map.put(map, pos, Map.get(map, pos, 0) + increment)

  defp find_next(col, start_row, matrix) do
    Map.keys(matrix)
    |> Enum.filter(fn {_r, c} -> c == col end)
    |> Enum.filter(fn {r, _c} -> r > start_row end)
    |> Enum.sort()
    |> Enum.at(0)
  end

  def get_initial_structure2() do
    [h | t] =
      File.read!("lib/advent_of_code/aoc/day7_input.txt")
      |> String.split("\n")

    starting_column = String.graphemes(h) |> Enum.find_index(&(&1 == "S"))

    matrix =
      Enum.map(t, &String.graphemes/1)
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {row, row_index}, row_matrix ->
        Enum.with_index(row)
        |> Enum.reduce(row_matrix, fn {elem, col_index}, curr_matrix ->
          case elem do
            "^" -> Map.put(curr_matrix, {row_index, col_index}, 0)
            "." -> curr_matrix
          end
        end)
      end)

    {max_row, _} = Map.keys(matrix) |> Enum.max_by(fn {r, _c} -> r end)

    matrix =
      Enum.reduce(0..length(String.graphemes(h)), matrix, fn idx, acc ->
        Map.put(acc, {max_row + 1, idx}, 0)
      end)

    {starting_column, matrix, max_row + 1}
  end

  defp print_matrix(m) do
    Enum.map(0..15, fn x ->
      Enum.map(0..15, fn y ->
        Map.get(m, {x, y})
        |> case do
          nil -> "."
          value -> Integer.to_string(value)
        end
      end)
      |> Enum.join(" ")
      |> IO.inspect()
    end)

    IO.inspect("__________________")
    m
  end
end

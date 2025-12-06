defmodule AdventOfCode.Day5 do
  def t do
    [ranges, product_ids] =
      File.read!("lib/advent_of_code/aoc/day5_input.txt")
      |> String.split("\n\n")

    r1 = resolve_part_1(ranges, product_ids)
    r2 = resolve_part_2(ranges)
    {r1, r2}
  end

  defp resolve_part_1(ranges, product_ids) do
    ranges =
      ranges
      |> String.split("\n")
      |> Enum.map(fn r ->
        [h, t] = String.split(r, "-")
        {String.to_integer(h), String.to_integer(t)}
      end)

    product_ids
    |> String.split("\n")
    |> Enum.filter(fn p ->
      p_int = String.to_integer(p)
      Enum.any?(ranges, fn {h, t} -> p_int >= h && p_int <= t end)
    end)
    |> length
  end

  defp resolve_part_2(ranges) do
    ranges
    |> String.split("\n")
    |> Enum.map(fn r ->
      [h, t] = String.split(r, "-")
      {String.to_integer(h), String.to_integer(t)}
    end)
    |> merge_ranges()
    |> Enum.reduce(0, fn
      {nil, nil}, acc -> acc
      {h, t}, acc -> acc + (t - h + 1)
    end)
  end

  defp merge_ranges(ranges) do
    ranges
    |> Enum.sort()
    |> Enum.reduce([], fn {h, t}, acc ->
      case acc do
        [] ->
          [{h, t}]

        [{last_h, last_t} | rest] ->
          if h <= last_t + 1 do
            [{last_h, max(last_t, t)} | rest]
          else
            [{h, t} | acc]
          end
      end
    end)
    |> Enum.reverse()
  end

  defp parse_range(range_list, h, t) do
    # IO.inspect "INIZIO PER #{h} - #{t} in lista #{inspect(range_list)}"
    Enum.reduce_while(range_list, [{h, t}], fn {h_range, t_range}, acc_ranges ->
      l =
        Enum.flat_map(acc_ranges, fn {h_acc, t_acc} ->
          cond do
            h_acc < h_range && t_acc > t_range -> [{h_acc, h_range - 1}, {t_range + 1, t}]
            h_acc > h_range && t_acc < t_range -> [nil]
            h_acc < h_range && t_acc > h_range -> [{h_acc, h_range - 1}]
            h_acc < t_range && t_acc > t_range -> [{t_range + 1, t_acc}]
            true -> [{h_acc, t_acc}]
          end
        end)
        |> Enum.reject(&is_nil/1)

      case l do
        [] -> {:halt, []}
        _ -> {:cont, l}
      end

      # |> IO.inspect
    end)
  end
end

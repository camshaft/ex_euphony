#!/usr/bin/env elixir

defmodule Parser do
  def parse(bin, acc \\ [])

  def parse("[" <> bin, acc) do
    {count, "]" <> rest} = Integer.parse(bin)
    parse(rest, [{count} | acc])
  end
  def parse(" " <> bin, acc) do
    parse(bin, acc)
  end
  def parse(bin, acc) do
    case Integer.parse(bin) do
      :error ->
        {case :lists.reverse(acc) do
          [{n} | l] ->
            [n | l]
          l ->
            [0 | l]
        end, parse_names(bin)}
      {count, rest} ->
        parse(rest, [count | acc])
    end
  end

  defp parse_names(bin) do
    bin
    |> String.split(",")
    |> Enum.map(fn(name) ->
      name
      |> String.trim()
      |> String.replace(" ", "_")
      |> String.replace("-", "_")
      |> String.replace("\"", "")
      |> String.replace("(", "")
      |> String.replace(")", "")
      |> String.replace("/", "_")
      |> String.replace(":_", "_")
      |> String.replace(":", "_")
      |> String.replace("'", "")
      |> String.replace("_+_", "+")
      |> String.replace("._", ".")
      |> String.replace("`", "")
      |> String.downcase()
      |> String.to_atom()
    end)
  end
end

{scales, aliases} = System.argv()
|> hd()
|> File.read!()
|> String.replace("\\\n", "")
|> String.split("\n")
|> Stream.map(fn(line) ->
  line
  |> String.split("!")
  |> hd()
  |> String.trim()
end)
|> Stream.filter(fn
  ("!" <> _) -> false
  ("") -> false
  (_) -> true
end)
|> Stream.drop(2)
|> Enum.map_reduce(%{minor: :"g.m.hypodorian"}, fn(line, acc) ->
  {scale, [name | aliases]} = Parser.parse(line)
  acc = Enum.reduce(aliases, acc, &Map.put(&2, &1, name))
  {{name, scale}, acc}
end)

scales = Enum.reduce(scales, %{}, fn({name, tuple}, acc) ->
  Map.update(acc, name, [tuple], &[tuple | &1])
end)

module = [
  "-module(musix_scale).",
  "-export([db/0, resolve/1]).",
  "db() -> \#{",
    scales
    |> Enum.sort_by(&elem(&1, 0))
    |> Stream.map(fn({name, scales}) ->
      scales = Enum.reduce(scales, %{}, fn(scale, acc) ->
        interval_count = Enum.reduce(scale, 0, &(&1 + &2))
        scale = scale |> Stream.scan(0, &(&1 + &2)) |> Enum.drop(-1)
        Map.put(acc, interval_count, :erlang.list_to_tuple(scale))
      end)
      :io_lib.format('    ~w => ~w', [name, scales])
    end)
    |> Enum.join(",\n"),
  "  }.",

  """
  resolve(Name) ->
    case Name of
  """,
  aliases
  |> Enum.sort_by(&elem(&1, 0))
  |> Enum.map(fn({from, to}) ->
    :io_lib.format('    ~w -> ~w;~n', [from, to])
  end),
  """
      _ -> Name
    end.
  """,
]
|> Enum.join("\n")

File.mkdir_p!("src")
File.write!("src/musix_scale.erl", module)

#!/usr/bin/env elixir

scales = System.argv()
|> hd()
|> Kernel.<>("/*.scl")
|> Path.wildcard()
|> Stream.map(fn(file) ->
  name =
    file
    |> Path.basename(".scl")
    |> String.replace("-", "_")
    |> String.replace(" ", "_")
    |> String.to_atom()
  {name, File.read!(file)}
end)
|> Stream.map(fn({name, file}) ->
  {name, file
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
  |> Enum.map(fn
    ("2") ->
      2
    (line) ->
      case Float.parse(line) do
        {cents, rest} when rest in ["", " cents"] ->
          :math.pow(2, cents / 1200)
        _ ->
          case String.split(line, "/") do
            [num, den] ->
              num = num |> String.replace(",", "") |> String.to_integer()
              den = den |> String.replace(",", "") |> String.to_integer()
              Ratio.new(num, den)
            _ ->
              case Integer.parse(line) do
                {cents, rest} when rest in ["", "."] ->
                  :math.pow(2, cents / 1200)
              end
          end
      end
  end)}
end)
|> Stream.map(fn({name, pitches}) ->
  {name, :erlang.list_to_tuple(pitches)}
end)
|> Stream.concat(
  Stream.map(1..150, fn(count) ->
    name = :"edo_#{count}"
    scale = Enum.map(1..count, fn(i) ->
      case :math.pow(2, i/count) do
        v when trunc(v) == v ->
          trunc(v)
        v ->
          v
      end
    end)
    {name, :erlang.list_to_tuple(scale)}
  end)
)

module = [
  "-module(musix_tuning).",
  "-export([db/0]).",
  "db() -> \#{",
    scales
    |> Enum.sort_by(&elem(&1, 0))
    |> Stream.map(fn({name, tuple}) ->
      :io_lib.format('    ~w => ~w', [name, tuple])
    end)
    |> Enum.join(",\n"),
  "  }."
]
|> Enum.join("\n")

File.mkdir_p!("src")
File.write!("src/musix_tuning.erl", module)

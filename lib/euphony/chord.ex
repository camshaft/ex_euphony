use Multix
alias Euphony.Math

defmodule Euphony.Chord do
  defstruct [name: nil, intervals: nil, value: %Euphony.Event{}]

  defmulti chord(name), priority: -1 do
    case fetch(name) do
      {:ok, intervals} ->
        %__MODULE__{
          name: name,
          intervals: intervals
        }
      _ ->
        raise ArgumentError, "#{inspect(name)} chord not found"
    end
  end

  chords = %{
    triad: %{7 => [0, 2, 4]},
    sixth: %{7 => [0, 2, 4, 5]},
    seventh: %{7 => [0, 2, 4, 6]},
    ninth: %{7 => [0, 2, 4, 8]},
    eleventh: %{7 => [0, 2, 4, 8, 10]}
  }
  |> Stream.map(fn({name, scales}) ->
    {name, Enum.reduce(scales, %{}, fn({size, degrees}, acc) ->
      degrees = Enum.map(degrees, &Math.div(&1, size))
      Map.put(acc, size, degrees)
    end)}
  end)
  |> Enum.into(%{})

  def db() do
    unquote(Macro.escape(chords))
  end

  def fetch(name) do
    Map.fetch(db(), name)
  end
  def fetch(name, scale_size) do
    case fetch(name) do
      {:ok, scales} ->
        Map.fetch(scales, scale_size)
      error ->
        error
    end
  end

  def get(name) do
    Map.get(db(), name)
  end
  def get(name, scale_size) do
    case fetch(name) do
      {:ok, scales} ->
        Map.get(scales, scale_size)
      _ ->
        nil
    end
  end

  def degrees(name, scale_size \\ 7) do
    case fetch(name, scale_size) do
      {:ok, degrees} ->
        degrees
      _ ->
        raise ArgumentError, "invalid chord: #{name} (#{scale_size})"
    end
  end

  def invert(degrees, 0) do
    degrees
  end
  def invert(degrees, _count) do
    # TODO
    degrees
  end

  defimpl Enumerable do
    def count(_) do
      {:error, __MODULE__}
    end

    def member?(_, _) do
      {:error, __MODULE__}
    end

    def reduce(%{intervals: %{7 => intervals}}, acc, fun) do
      Enumerable.reduce(intervals, acc, fun)
    end
  end
end

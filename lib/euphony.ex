use Multix

defmodule Euphony do
  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__)
      import unquote(__MODULE__).Event, only: [event: 0, event: 1, event_props: 2]
      import unquote(__MODULE__).Chord, only: [chord: 1]
      import unquote(__MODULE__).Scale, only: [scale: 1]
      import unquote(__MODULE__).Tuning, only: [tuning: 1]
      import unquote(__MODULE__).{Tempo,HSeq,VSeq}
      use Euphony.Math
      use Multix
      import Nile.Random
    end
  end

  @doc """
  Repeat a value `count` times
  """

  defmulti repeat(value, count \\ 2)
  defmulti repeat(value, count) do
    case count do
      0 ->
        []
      _ ->
        1..count |> Stream.map(fn(_) -> value end)
    end
  end

  defmodule UnificationError do
    defexception [:lhs, :rhs, :reason]

    def message(%{reason: nil, lhs: lhs, rhs: rhs}) do
      "Could not unify #{inspect(rhs)} into #{inspect(lhs)}"
    end
    def message(%{reason: reason, lhs: lhs, rhs: rhs}) do
      "Could not unify #{inspect(rhs)} into #{inspect(lhs)} (#{reason})"
    end
  end

  @doc """
  Unify values from right to left.

  This is a form of a strict merge where existing values should
  be consistent between both arguments
  """

  defmulti unify(a, b)

  defmulti unify(%Stream{} = a, %Stream{} = b) do
    Stream.zip(a, b)
    |> Stream.map(fn({a, b}) -> unify(a, b) end)
  end
  defmulti unify(%Stream{} = s, v) do
    Stream.map(s, &unify(&1, v))
  end

  @doc """
  Merge values from right to left
  """

  defmulti merge(a, b)

  defmulti merge(%Stream{} = a, %Stream{} = b) do
    Stream.zip(a, b)
    |> Stream.map(fn({a, b}) -> merge(a, b) end)
  end
  defmulti merge(%Stream{} = s, v) do
    Stream.map(s, &merge(&1, v))
  end

  @doc """
  Flatten the sequence into a list of events
  """

  def sequence(seq) do
    {events, _} = sequence(seq, 0)
    # TODO replace this with a deep flatten stream
    :lists.flatten(events)
  end

  @doc """
  Flatten the sequence into a list of events with a start offset
  """

  defmulti sequence(seq, offset)

  @doc """
  Shift values in a unit direction
  """

  defmulti shift(value, units)

  @doc """

  """

  defmulti rotr90(value)

  @doc """

  """

  defmulti rotl90(value)

  @doc """

  """

  defmulti rot180(value)
end

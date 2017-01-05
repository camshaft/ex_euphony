use Multix

defmodule Euphony.Tuning do
  defstruct [:name, :intervals]
  alias :euphony_tuning, as: T
  alias Euphony.Math, as: M

  defmulti tuning(name), priority: -1 do
    case fetch(name) do
      {:ok, intervals} ->
        %__MODULE__{
          name: name,
          intervals: intervals
        }
      _ ->
        raise ArgumentError, "#{inspect(name)} tuning not found"
    end
  end

  def size(%{intervals: i}) do
    tuple_size(i)
  end

  def db() do
    T.db()
  end

  def fetch(name) when is_atom(name) do
    Map.fetch(T.db(), name)
  end

  def get(name) when is_atom(name) do
    Map.get(T.db(), name)
  end

  def to_freq(name, base, idx) when is_atom(name) do
    case fetch(name) do
      {:ok, scale} ->
        to_freq(scale, base, idx)
      _ ->
        raise ArgumentError, message: "invalid tuning: #{name}"
    end
  end
  def to_freq(%__MODULE__{intervals: i}, base, idx) do
    to_freq(i, base, idx)
  end
  def to_freq(scale, base, idx) when is_tuple(scale) do
    count = tuple_size(scale)
    r = rem(idx, count)
    octave = case div(idx, count) do
      o when r >= 0 -> o
      o -> o - 1
    end
    octave_pos = :math.pow(scale |> elem(count - 1) |> M.to_float(), octave)
    freq = base |> M.mult(octave_pos) |> M.to_float()
    case r do
      0 ->
        1
      degree when degree >= 0 ->
        scale |> elem(degree - 1) |> M.to_float()
      degree ->
        scale |> elem(count + degree - 1) |> M.to_float()
    end * freq
  end
end

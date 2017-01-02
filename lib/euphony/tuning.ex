defmodule Euphony.Tuning do
  alias :euphony_tuning, as: T
  alias Numbers, as: N

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
  def to_freq(scale, base, idx) when is_tuple(scale) do
    count = tuple_size(scale)
    r = rem(idx, count)
    octave = case div(idx, count) do
      o when r >= 0 -> o
      o -> o - 1
    end
    octave_pos = :math.pow(scale |> elem(count - 1) |> N.to_float(), octave)
    freq = base |> N.mult(octave_pos) |> N.to_float()
    case r do
      0 ->
        1
      degree when degree >= 0 ->
        scale |> elem(degree - 1) |> Ratio.to_float()
      degree ->
        scale |> elem(count + degree - 1) |> Ratio.to_float()
    end * freq
  end
end

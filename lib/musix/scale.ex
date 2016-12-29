defmodule Musix.Scale do
  alias :musix_scale, as: T

  def db() do
    T.db()
  end

  def fetch(name) when is_atom(name) do
    Map.fetch(T.db(), T.resolve(name))
  end
  def fetch(name, tuning_size) do
    case fetch(name) do
      {:ok, scales} ->
        Map.fetch(scales, tuning_size)
      error ->
        error
    end
  end

  def get(name) when is_atom(name) do
    Map.get(T.db(), T.resolve(name))
  end
  def get(name, tuning_size) do
    case fetch(name) do
      {:ok, scales} ->
        Map.get(scales, tuning_size)
      _ ->
        nil
    end
  end

  def position(scale, degree, tuning_size \\ 12)
  for offset <- 0..100 do
    degree_bin = RomanNumerals.encode(offset + 1)
    lower_bin = degree_bin |> String.downcase()
    values = [
      degree_bin,
      degree_bin |> String.to_atom(),
      lower_bin,
      lower_bin |> String.to_atom()
    ]
    def position(scale, degree, tuning_size) when degree in unquote(values) do
      position(scale, unquote(offset), tuning_size)
    end
  end
  def position(scale, degree, tuning_size) when is_binary(degree) do
    offset = (degree |> String.upcase |> RomanNumerals.decode) + 1
    position(scale, offset, tuning_size)
  end
  def position(name, degree, tuning_size) when is_atom(name) do
    case fetch(name) do
      {:ok, scales} ->
        case Map.fetch(scales, tuning_size) do
          {:ok, scale} ->
            position(scale, degree, tuning_size, 1)
          _ ->
            find_compatible_scale(scales, degree, tuning_size)
        end
      _ ->
        raise ArgumentError, message: "invalid scale: #{name}"
    end
  end
  def position(scale, degree, tuning_size) do
    position(scale, degree, tuning_size, 1)
  end

  defp position(scale, %{numerator: num, denominator: den}, tuning_size, multiplier) when scale |> tuple_size() |> rem(den) == 0 do
    degree = num * (scale |> tuple_size() |> div(den))
    position(scale, degree, tuning_size, multiplier)
  end
  defp position(scale, degree, tuning_size, multiplier) when is_tuple(scale) and is_integer(degree) do
    size = tuple_size(scale)

    r = rem(degree, size)

    octave = case div(degree, size) do
      o when r >= 0 -> o
      o -> o - 1
    end * tuning_size

    case r do
      0 ->
        0
      degree when degree >= 0 ->
        scale |> elem(degree)
      degree ->
        scale |> elem(size + degree)
    end * multiplier + octave
  end

  defp find_compatible_scale(scales, degree, tuning_size) do
    {multiplier, scale} = scales
    |> Stream.flat_map(fn
      ({size, scale}) when rem(tuning_size, size) == 0 ->
        [{div(tuning_size, size), scale}]
      (_) ->
        []
    end)
    |> Enum.min_by(&elem(&1, 0))

    position(scale, degree, tuning_size, multiplier)
  rescue
    Enum.EmptyError ->
      raise ArgumentError, message: "invalid tuning size: #{tuning_size} for #{inspect(Map.keys(scales), charlists: :as_lists)}"
  end
end

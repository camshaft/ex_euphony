use Multix

alias Euphony.Math

defmodule Euphony.Tempo do
  defstruct [bpm: 120, base: Ratio.new(1,4)]

  def tempo(bpm \\ 120, base \\ %Ratio{numerator: 1, denominator: 4})
  def tempo(%__MODULE__{base: base} = t, base), do: t
  def tempo(%__MODULE__{bpm: bpm, base: from}, to), do: tempo(Math.mult(Math.div(from, to), bpm), to)
  def tempo(bpm, base) do
    %__MODULE__{bpm: bpm, base: base}
  end

  def to_seconds(%__MODULE__{bpm: bpm, base: base}, a) do
    Math.mult(
      Math.div(60, bpm),
      Math.div(a, base)
    )
  end
  def to_seconds(bpm, a) do
    %__MODULE__{bpm: bpm}
    |> to_seconds(a)
  end

  import Kernel, except: [div: 2]
  for method <- [:add, :sub, :mult, :div] do
    defmulti Math.unquote(method)(%__MODULE__{} = s, num), do: unquote(method)(s, num)
    defmulti Math.unquote(method)(num, %__MODULE__{} = s), do: unquote(method)(num, s)

    defp unquote(method)(a, b) do
      {base, a, b} = convert(a, b)
      %__MODULE__{base: base, bpm: Math.unquote(method)(a, b)}
    end
  end

  defp convert(%__MODULE__{base: base, bpm: a}, b) do
    b = case b do
      %__MODULE__{bpm: b, base: b_base} ->
        Math.mult(Math.div(b_base, base), b)
      b ->
        b
    end
    {base, a, b}
  end
  defp convert(a, b) do
    a
    |> tempo()
    |> convert(b)
  end
end

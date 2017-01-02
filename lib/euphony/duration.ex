use Multix

alias Euphony.Math

defmodule Euphony.Tempo do
  defstruct [bpm: 120, base: Ratio.new(1,4)]

  def tempo(bpm \\ 120, base \\ %Ratio{numerator: 1, denominator: 4}) do
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

  # TODO support unquote in multix

  defmulti Math.add(%{__struct__: __MODULE__, bpm: bpm} = s, num) do
    %{s | bpm: Math.add(bpm, num)}
  end
  defmulti Math.add(num, %{__struct__: __MODULE__, bpm: bpm} = s) do
    %{s | bpm: Math.add(bpm, num)}
  end
  defmulti Math.sub(%{__struct__: __MODULE__, bpm: bpm} = s, num) do
    %{s | bpm: Math.sub(bpm, num)}
  end
  defmulti Math.sub(num, %{__struct__: __MODULE__, bpm: bpm} = s) do
    %{s | bpm: Math.sub(bpm, num)}
  end
  defmulti Math.mult(%{__struct__: __MODULE__, bpm: bpm} = s, num) do
    %{s | bpm: Math.mult(bpm, num)}
  end
  defmulti Math.mult(num, %{__struct__: __MODULE__, bpm: bpm} = s) do
    %{s | bpm: Math.mult(bpm, num)}
  end
  defmulti Math.div(%{__struct__: __MODULE__, bpm: bpm} = s, num) do
    %{s | bpm: Math.div(bpm, num)}
  end
  defmulti Math.div(num, %{__struct__: __MODULE__, bpm: bpm} = s) do
    %{s | bpm: Math.div(bpm, num)}
  end
end

defmodule Euphony.Duration do
  defmulti to_seconds(value)
end

#
# defmulti Euphony.Duration do
#   def to_picosecond(value)
# end
#
# defdispatch Euphony.Duration, for: %Euphony.Event{props: %{duration_ps: _}} do
#   def to_picosecond(%{props: %{duration_ps: ps}}) do
#     ps
#   end
# end
#
# defdispatch Euphony.Duration, for: %Euphony.Event{props: %{duration: {_, _}, bpm: _}} do
#   alias Numbers, as: N
#
#   @picseconds_in_a_minute 6.0e+13 |> trunc()
#   @base N.mult(4, @picseconds_in_a_minute)
#
#   def to_picosecond(%{props: %{duration: {num, den}, bpm: bpm}}) do
#     @base
#     |> N.mult(num)
#     |> N.div(N.mult(den, bpm))
#     |> N.to_float()
#     |> trunc()
#   end
# end
#
# defdispatch Euphony.Duration, for: %Euphony.Event{props: %{duration: {_, _}}} do
#   def to_picosecond(%{props: props} = event) do
#     %{event | props: Map.put(props, :bpm, 120)}
#     |> Euphony.Duration.to_picosecond()
#   end
# end
#
# defdispatch Euphony.Duration, for: %Euphony.Event{}, index: -1 do
#   def to_picosecond(_) do
#     0
#   end
# end

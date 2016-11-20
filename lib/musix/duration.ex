use Multix

defmulti Musix.Duration do
  def to_picosecond(value)
end

defdispatch Musix.Duration, for: %Musix.Event{props: %{duration_ps: _}} do
  def to_picosecond(%{props: %{duration_ps: ps}}) do
    ps
  end
end

defdispatch Musix.Duration, for: %Musix.Event{props: %{duration: {_, _}, bpm: _}} do
  alias Decimal, as: D

  @picseconds_in_a_minute 6.0e+13 |> trunc() |> D.new()
  @base D.mult(D.new(4), @picseconds_in_a_minute)

  def to_picosecond(%{props: %{duration: {num, den}, bpm: bpm}}) do
    @base
    |> D.mult(D.new(num))
    |> D.div(D.mult(D.new(den), D.new(bpm)))
    |> D.to_float()
    |> trunc()
  end
end

defdispatch Musix.Duration, for: %Musix.Event{props: %{duration: {_, _}}} do
  def to_picosecond(%{props: props} = event) do
    %{event | props: Map.put(props, :bpm, 120)}
    |> Musix.Duration.to_picosecond()
  end
end

defdispatch Musix.Duration, for: %Musix.Event{}, index: -1 do
  def to_picosecond(_) do
    0
  end
end

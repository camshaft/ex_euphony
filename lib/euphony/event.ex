use Multix
use Euphony.Math

defmodule Euphony.Event do
  defstruct [props: %{}]

  def event(props \\ %{})
  def event(%__MODULE__{} = e) do
    e
  end
  def event(%{__struct__: _} = props) do
    try do
      Enum.into(props, %__MODULE__{})
    rescue
      Protocol.UndefinedError ->
        raise ArgumentError, "Invalid event props: #{inspect(props)}"
    end
  end
  def event(props) when is_map(props) do
    %__MODULE__{props: props}
  end
  def event({k, v}) do
    %__MODULE__{props: %{k => v}}
  end
  def event(props) do
    try do
      Enum.into(props, event())
    rescue
      Protocol.UndefinedError ->
        raise ArgumentError, "Invalid event props: #{inspect(props)}"
    end
  end

  def event_props(stream, key) do
    stream
    |> Stream.map(fn(value) ->
      %__MODULE__{props: %{key => value}}
    end)
  end

  @behaviour Access
  def fetch(%{props: props}, key) do
    Map.fetch(props, key)
  end

  def get(%{props: props}, key, default) do
    Map.get(props, key, default)
  end

  def get_and_update(point = %{props: props}, key, value) do
    {value, props} = Map.get_and_update(props, key, value)
    {value, %{point | props: props}}
  end

  def pop(point = %{props: props}, key) do
    {value, props} = Map.pop(props, key)
    {value, %{point | props: props}}
  end

  import Euphony
  defmulti unify(%__MODULE__{props: a} = a_e, %__MODULE__{props: b} = b_e) do
    %__MODULE__{props: Map.merge(a, b, fn
      (_k, v, v) ->
        v
      (k, _v1, _v2) ->
        raise Euphony.UnificationError, lhs: a_e, rhs: b_e, reason: "#{inspect(k)} doesn't match"
    end)}
  end
  defmulti unify(%__MODULE__{} = a, other) do
    unify(a, event(other))
  end

  defmulti merge(%__MODULE__{props: a}, %__MODULE__{props: b}) do
    %__MODULE__{props: Map.merge(a, b)}
  end
  defmulti merge(%__MODULE__{} = a, other) do
    merge(a, event(other))
  end

  alias Euphony.{Duration,Frequency,Tempo}

  defmulti sequence(%__MODULE__{} = e, offset) do
    s = Duration.to_seconds(e)
    {[merge(e, %{offset_s: offset, duration_s: s})], offset + s}
  end

  import Duration
  defmulti to_seconds(%__MODULE__{props: %{duration_s: s}}) do
    s
  end
  defmulti to_seconds(%__MODULE__{props: %{duration: d, tempo: t}}) do
    Tempo.to_seconds(t, d)
  end
  defmulti to_seconds(%__MODULE__{props: %{duration: d}}) do
    Tempo.to_seconds(120, d)
  end
  defmulti to_seconds(%__MODULE__{}), priority: -1 do
    0
  end

  import Frequency
  alias Euphony.{Tuning,Scale,Math}
  defmulti to_freq(%__MODULE__{props: %{tonic: t} = p} = e) when is_atom(t) do
    %{e | props: %{p | tonic: Euphony.ChromaticNote.new(t)}}
    |> to_freq()
  end
  defmulti to_freq(%__MODULE__{props: %{pitch_standard: {pitch, freq}} = p} = e) when is_atom(pitch) do
    %{e | props: %{p | pitch_standard: {Euphony.ChromaticNote.new(pitch), freq}}}
    |> to_freq()
  end
  defmulti to_freq(%__MODULE__{props:
    %{degree: degree, scale: scale, tonic: tonic, tuning: tuning, pitch_standard: {pitch, freq}}
  }) do
    tuning = Tuning.tuning(tuning)
    scale = Scale.scale(scale)

    tuning_size = Tuning.size(tuning)
    position = Math.to_integer((tonic - pitch) + Scale.position(scale, degree, tuning_size))
    Tuning.to_freq(tuning, freq, position)
  end
  defmulti to_freq(%__MODULE__{props: %{degree: d, scale: s, tonic: t} = p} = e) do
    defaults = %{tuning: :edo_12, pitch_standard: {Euphony.ChromaticNote.new(:A4), 440}}
    %{e | props: Map.merge(defaults, p)}
    |> to_freq()
  end

  defimpl Collectable do
    def into(%{props: props}) do
      {init, fun} = @protocol.into(props)
      {init, fn
        (acc, :done) ->
          %@for{props: fun.(acc, :done)}
        (acc, command) ->
          fun.(acc, command)
      end}
    end
  end
end

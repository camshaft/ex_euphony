use Multix
use Euphony.Math

defmodule Euphony.Event do
  defstruct [props: %{}]

  def event(props \\ %{})
  def event(%__MODULE__{} = e) do
    e
  end
  def event(props) when is_map(props) do
    %__MODULE__{props: props}
  end
  def event(props) when is_list(props) do
    props
    |> Enum.into(%{})
    |> event()
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

  import Euphony, only: [unify: 2, merge: 2]
  defmulti unify(%{__struct__: __MODULE__, props: a} = a_e, %{__struct__: __MODULE__, props: b} = b_e) do
    %__MODULE__{props: Map.merge(a, b, fn
      (_k, v, v) ->
        v
      (k, _v1, _v2) ->
        raise Euphony.UnificationError, lhs: a_e, rhs: b_e, reason: "#{inspect(k)} doesn't match"
    end)}
  end
  defmulti unify(%{__struct__: __MODULE__} = a, other) do
    unify(a, event(other))
  end

  defmulti merge(%{__struct__: __MODULE__, props: a}, %{__struct__: __MODULE__, props: b}) do
    %__MODULE__{props: Map.merge(a, b)}
  end
  defmulti merge(%{__struct__: __MODULE__} = a, other) do
    merge(a, event(other))
  end

  alias Euphony.{Duration,Tempo}

  import Duration
  # TODO match on the struct: we're getting a deadlock problem
  defmulti to_seconds(%{__struct__: __MODULE__, props: %{duration_s: s}}) do
    s
  end
  defmulti to_seconds(%{__struct__: __MODULE__, props: %{duration: d, tempo: t}}) do
    Tempo.to_seconds(t, d)
  end
  defmulti to_seconds(%{__struct__: __MODULE__, props: %{duration: d}}) do
    Tempo.to_seconds(120, d)
  end
  defmulti to_seconds(%{__struct__: __MODULE__}), priority: -1 do
    0
  end
end

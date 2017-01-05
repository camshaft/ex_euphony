use Multix

defmodule Euphony.HSeq do
  defstruct [elements: []]

  def hseq(elements) do
    %__MODULE__{elements: elements}
  end

  import Euphony
  defmulti sequence(%__MODULE__{elements: e}, offset) do
    Enum.flat_map_reduce(e, offset, &sequence/2)
  end
end

defmodule Euphony.VSeq do
  defstruct [elements: []]

  def vseq(elements) do
    %__MODULE__{elements: elements}
  end

  import Euphony
  defmulti sequence(%__MODULE__{elements: e}, offset) do
    Enum.flat_map_reduce(e, offset, fn(i, prev) ->
      case sequence(i, offset) do
        {events, new} when new > prev ->
          {events, new}
        {events, _} ->
          {events, prev}
      end
    end)
  end
end

defimpl Enumerable, for: [Euphony.HSeq,Euphony.VSeq] do
  def count(%{elements: elements}) do
    case @protocol.count(elements) do
      {:ok, count} ->
        {:ok, count}
      _ ->
        {:error, __MODULE__}
    end
  end

  def member?(%{elements: elements}, value) do
    case @protocol.member?(elements, value) do
      {:ok, member?} ->
        {:ok, member?}
      _ ->
        {:error, __MODULE__}
    end
  end

  def reduce(%{elements: elements}, acc, fun) do
    @protocol.reduce(elements, acc, fun)
  end
end

defmodule Euphony.AbstractSequence do
  import Euphony

  defmulti unify(%{__struct__: a_s, elements: a_e},
                 %{__struct__: b_s, elements: b_e})
    when a_s in [Euphony.HSeq, Euphony.VSeq] and b_s in [Euphony.HSeq, Euphony.VSeq] do
    _ = b_s
    %{
      __struct__: a_s,
      elements: a_e |> Stream.zip(b_e) |> Stream.map(&unify/2)
    }
  end
  defmulti unify(%{__struct__: a_s, elements: a_e}, b)
    when a_s in [Euphony.HSeq, Euphony.VSeq] do
    %{
      __struct__: a_s,
      elements: a_e |> Stream.map(&(unify&1, b))
    }
  end
  defmulti unify(a, %{__struct__: b_s, elements: b_e})
    when b_s in [Euphony.HSeq, Euphony.VSeq] do
    %{
      __struct__: b_s,
      elements: b_e |> Stream.map(&(unify&1, a))
    }
  end

  defmulti merge(%{__struct__: a_s, elements: a_e},
                 %{__struct__: b_s, elements: b_e})
    when a_s in [Euphony.HSeq, Euphony.VSeq] and b_s in [Euphony.HSeq, Euphony.VSeq] do
    _ = b_s
    %{
      __struct__: a_s,
      elements: a_e |> Stream.zip(b_e) |> Stream.map(&merge/2)
    }
  end
  defmulti merge(%{__struct__: a_s, elements: a_e}, b)
    when a_s in [Euphony.HSeq, Euphony.VSeq] do
    %{
      __struct__: a_s,
      elements: a_e |> Stream.map(&(merge&1, b))
    }
  end
  defmulti merge(a, %{__struct__: b_s, elements: b_e})
    when b_s in [Euphony.HSeq, Euphony.VSeq] do
    %{
      __struct__: b_s,
      elements: b_e |> Stream.map(&(merge&1, a))
    }
  end
end

defmodule Musix do
  def event(props \\ %{})
  def event(props) when is_map(props) do
    %Musix.Event{props: props}
  end
  def event(props) when is_list(props) do
    props
    |> Enum.into(%{})
    |> event()
  end

  def hseq(elements \\ []) do
    %Musix.HSeq{elements: elements}
  end

  def vseq(elements \\ []) do
    %Musix.VSeq{elements: elements}
  end

  def repeat(element, count \\ 2) do
    Musix.Repeatable.repeat(element, count)
  end

  def unify(a, b) do
    Musix.Unifiable.unify(a, b)
  end

  def sequence(seq, start \\ 0) do
    {seq, _end} = Musix.Sequencable.sequence(seq, start)
    :lists.flatten(seq)
  end

  def cascade(element, props) when is_map(props) do
    %Musix.Cascade{element: element, props: props}
  end
  def cascade(element, props) do
    cascade(element, Enum.into(props, %{}))
  end

  def apply_cascade(elements, data \\ %{}) do
    Musix.Cascadable.cascade(elements, data)
  end

  def key(root, scale \\ :major) do
    Musix.Key.new(root, scale)
  end

  def shift(value, units) do
    Musix.Shiftable.shift(value, units)
  end
end

defmodule Musix.Cascade do
  defstruct [:element, :props]
end

defprotocol Musix.Cascadable do
  def cascade(struct, data \\ %{})
end

defimpl Musix.Cascadable, for: Musix.Event do
  def cascade(%{props: props} = e, data) do
    %{e | props: Map.merge(data, props)}
  end
end

defimpl Musix.Cascadable, for: Musix.Cascade do
  def cascade(%{element: element, props: props}, data) do
    data = Map.merge(data, props)
    @protocol.cascade(element, data)
  end
end

defimpl Musix.Cascadable, for: [Musix.HSeq, Musix.VSeq] do
  def cascade(%{elements: elements} = s, data) do
    e = Stream.map(elements, &@protocol.cascade(&1, data))
    %{s | elements: e}
  end
end

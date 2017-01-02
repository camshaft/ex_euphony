# defmodule Euphony.Cascade do
#   defstruct [:element, :props]
# end
#
# defprotocol Euphony.Cascadable do
#   def cascade(struct, data \\ %{})
# end
#
# defimpl Euphony.Cascadable, for: Euphony.Event do
#   def cascade(%{props: props} = e, data) do
#     %{e | props: Map.merge(data, props)}
#   end
# end
#
# defimpl Euphony.Cascadable, for: Euphony.Cascade do
#   def cascade(%{element: element, props: props}, data) do
#     data = Map.merge(data, props)
#     @protocol.cascade(element, data)
#   end
# end
#
# defimpl Euphony.Cascadable, for: [Euphony.HSeq, Euphony.VSeq] do
#   def cascade(%{elements: elements} = s, data) do
#     e = Stream.map(elements, &@protocol.cascade(&1, data))
#     %{s | elements: e}
#   end
# end

# defprotocol Euphony.Repeatable do
#   def repeat(element, count \\ 2)
# end
#
# defimpl Euphony.Repeatable, for: Euphony.Event do
#   def repeat(point, count) do
#     Stream.map(1..count, fn(_) ->
#       point
#     end)
#   end
# end
#
# defimpl Euphony.Repeatable, for: Euphony.VSeq do
#   def repeat(seq, count) do
#     elements = Stream.flat_map(1..count, fn(_) ->
#       seq
#     end)
#     %Euphony.HSeq{elements: elements}
#   end
# end
#
# defimpl Euphony.Repeatable, for: [List, Euphony.HSeq] do
#   def repeat(%{elements: elements}, count) do
#     repeat(elements, count)
#   end
#   def repeat(elements, count) do
#     elements = Stream.flat_map(1..count, fn(_) ->
#       elements
#     end)
#     %Euphony.HSeq{elements: elements}
#   end
# end

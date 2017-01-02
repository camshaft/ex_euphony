# defprotocol Euphony.Shiftable do
#   def shift(value, units)
# end
#
# defimpl Euphony.Shiftable, for: Euphony.ChromaticNote do
#   def shift(%{position: position, octave: octave}, units) do
#     (12 * octave) + position + units
#     |> @for.new()
#   end
# end
#
# defimpl Euphony.Shiftable, for: Euphony.Key do
#   def shift(%{root: root} = key, units) do
#     %{key | root: @protocol.shift(root, units)}
#   end
# end

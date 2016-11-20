defprotocol Musix.Shiftable do
  def shift(value, units)
end

defimpl Musix.Shiftable, for: Musix.ChromaticNote do
  def shift(%{position: position, octave: octave}, units) do
    (12 * octave) + position + units
    |> @for.new()
  end
end

defimpl Musix.Shiftable, for: Musix.Key do
  def shift(%{root: root} = key, units) do
    %{key | root: @protocol.shift(root, units)}
  end
end

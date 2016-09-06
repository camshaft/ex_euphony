defprotocol Musix.Repeatable do
  def repeat(element, count \\ 2)
end

defimpl Musix.Repeatable, for: Musix.Event do
  def repeat(point, count) do
    Stream.map(1..count, fn(_) ->
      point
    end)
  end
end

defimpl Musix.Repeatable, for: [Musix.HSeq, Musix.VSeq] do
  def repeat(seq = %{elements: elements}, count) do
    elements = Enum.flat_map(1..count, fn(_) ->
      elements
    end)
    %{seq | elements: elements}
  end
end

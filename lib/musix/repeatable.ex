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

defimpl Musix.Repeatable, for: Musix.VSeq do
  def repeat(seq, count) do
    elements = Stream.flat_map(1..count, fn(_) ->
      seq
    end)
    %Musix.HSeq{elements: elements}
  end
end

defimpl Musix.Repeatable, for: [List, Musix.HSeq] do
  def repeat(%{elements: elements}, count) do
    repeat(elements, count)
  end
  def repeat(elements, count) do
    elements = Stream.flat_map(1..count, fn(_) ->
      elements
    end)
    %Musix.HSeq{elements: elements}
  end
end

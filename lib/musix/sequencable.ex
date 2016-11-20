defprotocol Musix.Sequencable do
  def sequence(data, start \\ 0)
end

defimpl Musix.Sequencable, for: Musix.HSeq do
  def sequence(%{elements: elements}, start) do
    Enum.map_reduce(elements, start, &@protocol.sequence/2)
  end
end

defimpl Musix.Sequencable, for: Musix.VSeq do
  def sequence(%{elements: elements}, start) do
    Enum.map_reduce(elements, start, fn(el, offset) ->
      case @protocol.sequence(el, start) do
        {el, o} when o > offset ->
          {el, o}
        {el, _} ->
          {el, offset}
      end
    end)
  end
end

defimpl Musix.Sequencable, for: Musix.Event do
  def sequence(%{props: props} = event, start) do
    duration = Musix.Duration.to_picosecond(event)
    props = Map.merge(props, %{
      offset_ps: start,
      duration_ps: duration
    })
    {%{event | props: props}, start + duration}
  end
end

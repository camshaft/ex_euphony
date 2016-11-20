defprotocol Musix.Unifiable do
  def unify(a, b)

  Kernel.defoverridable [unify: 2]
  Kernel.def unify(%{__struct__: s} = a, %{__struct__: s} = b) do
    super(a, b)
  end
end

defimpl Musix.Unifiable, for: Musix.Event do
  def unify(%{props: a}, %{props: b}) do
    props = Map.merge(a, b, fn
      (_, v, v) ->
        v
    end)
    %@for{props: props}
  end
end

defimpl Musix.Unifiable, for: [Musix.HSeq, Musix.VSeq] do
  def unify(%{elements: a}, %{elements: b}) do
    a = Enum.to_list(a)
    b = Enum.to_list(b)
    %@for{elements: unify(a, b, [])}
  end

  defp unify([], [], acc) do
    :lists.reverse(acc)
  end
  defp unify([a | a_r], [b | b_r], acc) do
    value = @protocol.unify(a, b)
    unify(a_r, b_r, [value | acc])
  end
end

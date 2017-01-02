defmodule Euphony.HSeq do
  defstruct [elements: []]
end

defimpl Collectable, for: Euphony.HSeq do
  def into(%{elements: elements} = orig) do
    {[], fn
      (acc, {:cont, x}) ->
        [x | acc]
      (acc, :done) ->
        %{orig | elements: elements ++ :lists.reverse(acc)}
      (_, :halt) ->
        :ok
    end}
  end
end

defimpl Enumerable, for: Euphony.HSeq do
  def count(_) do
    {:error, __MODULE__}
  end

  def member?(_, _) do
    {:error, __MODULE__}
  end

  def reduce(%{elements: elements}, acc, fun) do
    Enumerable.reduce(elements, acc, fun)
  end
end

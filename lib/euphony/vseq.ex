defmodule Euphony.VSeq do
  defstruct [elements: []]
end

defimpl Collectable, for: Euphony.VSeq do
  def into(orig = %{elements: elements}) do
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

defimpl Enumerable, for: Euphony.VSeq do
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

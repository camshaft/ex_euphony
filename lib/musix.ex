defmodule Musix do
  def event(props \\ %{})
  def event(props) when is_map(props) do
    %Musix.Event{props: props}
  end
  def event(props) when is_list(props) do
    props
    |> Enum.into(%{})
    |> event()
  end

  def hseq(elements \\ []) do
    %Musix.HSeq{elements: elements}
  end

  def vseq(elements \\ []) do
    %Musix.VSeq{elements: elements}
  end

  def repeat(element, count \\ 2) do
    Musix.Repeatable.repeat(element, count)
  end

  def unify(a, b) do
    Musix.Unifiable.unify(a, b)
  end
end

defmodule Musix.Key do
  defstruct [root: 0,
             scale: :major]

  alias Musix.{ChromaticNote,Scale}

  def new(name, scale \\ :major)

  def new(root, scale) when is_atom(root) or is_binary(root) or is_integer(root) do
    root
    |> ChromaticNote.new()
    |> new(scale)
  end
  def new(root, scale) do
    %__MODULE__{
      root: root,
      scale: Scale.new(scale)
    }
  end

  def position(%{root: root, scale: scale}, offset) do
    position = Scale.position(scale, offset)
    Musix.Shiftable.shift(root, position)
  end
end

defimpl Inspect, for: Musix.Key do
  import Inspect.Algebra

  def inspect(%{root: root, scale: scale}, opts) do
    concat([
      "#Musix.Key<",
      @protocol.inspect(root, opts),
      " ",
      @protocol.inspect(scale, opts),
      ">"
    ])
  end
end

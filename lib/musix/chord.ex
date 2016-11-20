defmodule Musix.Chord do
  defstruct [:name, :positions]

  major  = {0, 4, 7}
  minor  = {0, 3, 7}
  major7 = {0, 4, 7, 11}
  dom7   = {0, 4, 7, 10}
  minor7 = {0, 3, 7, 10}
  aug    = {0, 4, 8}
  dim    = {0, 3, 6}
  dim7   = {0, 3, 6, 9}

  chords = %{
    "1":           {0},
    "5":           {0, 7},
    "+5":          {0, 4, 8},
    "m+5":         {0, 3, 8},
    "sus2":        {0, 2, 7},
    "sus4":        {0, 5, 7},
    "6":           {0, 4, 7, 9},
    "m6":          {0, 3, 7, 9},
    "7sus2":       {0, 2, 7, 10},
    "7sus4":       {0, 5, 7, 10},
    "7-5":         {0, 4, 6, 10},
    "m7-5":        {0, 3, 6, 10},
    "7+5":         {0, 4, 8, 10},
    "m7+5":        {0, 3, 8, 10},
    "9":           {0, 4, 7, 10, 14},
    "m9":          {0, 3, 7, 10, 14},
    "m7+9":        {0, 3, 7, 10, 14},
    "maj9":        {0, 4, 7, 11, 14},
    "9sus4":       {0, 5, 7, 10, 14},
    "6*9":         {0, 4, 7, 9, 14},
    "m6*9":        {0, 3, 9, 7, 14},
    "7-9":         {0, 4, 7, 10, 13},
    "m7-9":        {0, 3, 7, 10, 13},
    "7-10":        {0, 4, 7, 10, 15},
    "9+5":         {0, 10, 13},
    "m9+5":        {0, 10, 14},
    "7+5-9":       {0, 4, 8, 10, 13},
    "m7+5-9":      {0, 3, 8, 10, 13},
    "11":          {0, 4, 7, 10, 14, 17},
    "m11":         {0, 3, 7, 10, 14, 17},
    "maj11":       {0, 4, 7, 11, 14, 17},
    "11+":         {0, 4, 7, 10, 14, 18},
    "m11+":        {0, 3, 7, 10, 14, 18},
    "13":          {0, 4, 7, 10, 14, 17, 21},
    "m13":         {0, 3, 7, 10, 14, 17, 21},
    "major":       major,
    "M":           major,
    "minor":       minor,
    "m":           minor,
    "dom7":        dom7,
    "dominant7":   dom7,
    "7":           dom7,
    "major7":      major7,
    "M7":          major7,
    "minor7":      minor7,
    "m7":          minor7,
    "augmented":   aug,
    "a":           aug,
    "diminished":  dim,
    "dim":         dim,
    "i":           dim,
    "diminished7": dim7,
    "dim7":        dim7,
    "i7":          dim7,
  }

  for {name, positions} <- chords do
    display_name = case positions do
      ^major -> :major
      ^minor -> :minor
      ^major7 -> :major7
      ^dom7 -> :dominant7
      ^minor7 -> :minor7
      ^aug -> :augmented
      ^dim -> :diminished
      ^dim7 -> :diminished7
      _ -> name
    end
    def new(unquote(name)) do
      %__MODULE__{name: unquote(display_name), positions: unquote(Macro.escape(positions))}
    end
    def new(unquote(to_string(name))) do
      new(unquote(name))
    end
  end

  def new(positions) when is_tuple(positions) do
    new(positions, nil)
  end

  def new(name, positions) when is_tuple(positions) and is_atom(name) do
    %__MODULE__{positions: positions, name: name}
  end
  def new(positions, name) do
    new(name, positions)
  end

  defimpl Inspect do
    def inspect(%{name: name}, _opts) when not is_nil(name) do
      "#Musix.Chord<#{name}>"
    end
    def inspect(%{positions: positions}, _opts) do
      positions = positions |> :erlang.tuple_to_list() |> Enum.join(", ")
      "#Musix.Chord<#{positions}>"
    end
  end
end

defmodule Euphony.ChromaticNote do
  defstruct [:position, :octave]

  notes = %{
    "C":  0,
    "C#": 1,
    "D":  2,
    "Eb": 3,
    "E":  4,
    "F":  5,
    "F#": 6,
    "G":  7,
    "Ab": 8,
    "A":  9,
    "Bb": 10,
    "B":  11
  }

  aliases = %{
    "C-": -1,
    "Cb": -1,
    "C+": 1,
    "D-": 1,
    "Db": 1,
    "D#": 3,
    "E-": 3,
    "E+": 5,
    "E#": 5,
    "F-": 4,
    "Fb": 4,
    "G-": 6,
    "Gb": 6,
    "G+": 8,
    "G#": 8,
    "A-": 8,
    "A+": 10,
    "A#": 10,
    "B-": 10,
    "B+": 12,
    "B#": 12
  }

  for {note, v} <- Map.merge(notes, aliases),
      octave    <- 0..10 do

    {v, o} =
      cond do
        v == -1 ->
          {11, octave - 1}
        true ->
          {v, octave}
      end

    atom = :"#{note}#{octave}"
    lower_note = note |> to_string() |> String.downcase() |> String.to_atom()
    lower_atom = :"#{lower_note}#{octave}"

    values = [
      atom,
      atom |> to_string(),
      lower_atom,
      lower_atom |> to_string()
    ] ++ (if octave == 4 do
      [
        note,
        note |> to_string(),
        lower_note,
        lower_note |> to_string()
      ]
    else
      []
    end)

    def new(atom) when atom in unquote(values) do
      %__MODULE__{position: unquote(v), octave: unquote(o)}
    end
  end

  def new(num) when is_integer(num) and num >= 0 do
    %__MODULE__{
      octave: num |> div(12),
      position: num |> rem(12) |> abs()
    }
  end
  def new(num) when is_integer(num) and num < 0 do
    num = abs(num) - 1
    %__MODULE__{
      octave: -(div(num, 12) + 1),
      position: (11 - rem(num, 12))
    }
  end
  def new(name, octave) when is_atom(name) and is_integer(octave) do
    %{new(name) | octave: octave}
  end
  def new(position, octave) when is_integer(position) and is_integer(octave) do
    new(octave * 12 + position)
  end

  def list do
    unquote(Map.keys(notes))
  end

  defimpl Inspect do
    def inspect(note, _opts) do
      "#Euphony.ChromaticNote<#{note}>"
    end
  end

  defimpl String.Chars do
    @notes notes |> Stream.map(fn({k, v}) -> {v, k} end) |> Enum.into(%{})
    def to_string(%{position: position, octave: octave}) do
      "#{@notes[position]}#{octave}"
    end
  end
end

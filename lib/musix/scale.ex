defmodule Musix.Scale do
  defstruct [:name, :positions]

  ionian_sequence     = [2, 2, 1, 2, 2, 2, 1]
  hex_sequence        = [2, 2, 1, 2, 2, 3]
  pentatonic_sequence = [3, 2, 2, 3, 2]

  rotate = fn(seq, offset) ->
    {tail, head} = Enum.split(seq, offset)
    head ++ tail
  end

  scales = %{diatonic:           ionian_sequence,
             ionian:             rotate.(ionian_sequence, 0),
             major:              rotate.(ionian_sequence, 0),
             dorian:             rotate.(ionian_sequence, 1),
             phrygian:           rotate.(ionian_sequence, 2),
             lydian:             rotate.(ionian_sequence, 3),
             mixolydian:         rotate.(ionian_sequence, 4),
             aeolian:            rotate.(ionian_sequence, 5),
             minor:              rotate.(ionian_sequence, 5),
             locrian:            rotate.(ionian_sequence, 6),
             hex_major6:         rotate.(hex_sequence, 0),
             hex_dorian:         rotate.(hex_sequence, 1),
             hex_phrygian:       rotate.(hex_sequence, 2),
             hex_major7:         rotate.(hex_sequence, 3),
             hex_sus:            rotate.(hex_sequence, 4),
             hex_aeolian:        rotate.(hex_sequence, 5),
             minor_pentatonic:   rotate.(pentatonic_sequence, 0),
             yu:                 rotate.(pentatonic_sequence, 0),
             major_pentatonic:   rotate.(pentatonic_sequence, 1),
             gong:               rotate.(pentatonic_sequence, 1),
             egyptian:           rotate.(pentatonic_sequence, 2),
             shang:              rotate.(pentatonic_sequence, 2),
             jiao:               rotate.(pentatonic_sequence, 3),
             pentatonic:         rotate.(pentatonic_sequence, 4),
             zhi:                rotate.(pentatonic_sequence, 4),
             ritusen:            rotate.(pentatonic_sequence, 4),
             whole_tone:         [2, 2, 2, 2, 2, 2],
             whole:              [2, 2, 2, 2, 2, 2],
             chromatic:          [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
             harmonic_minor:     [2, 1, 2, 2, 1, 3, 1],
             melodic_minor_asc:  [2, 1, 2, 2, 2, 2, 1],
             hungarian_minor:    [2, 1, 3, 1, 1, 3, 1],
             octatonic:          [2, 1, 2, 1, 2, 1, 2, 1],
             messiaen1:          [2, 2, 2, 2, 2, 2],
             messiaen2:          [1, 2, 1, 2, 1, 2, 1, 2],
             messiaen3:          [2, 1, 1, 2, 1, 1, 2, 1, 1],
             messiaen4:          [1, 1, 3, 1, 1, 1, 3, 1],
             messiaen5:          [1, 4, 1, 1, 4, 1],
             messiaen6:          [2, 2, 1, 1, 2, 2, 1, 1],
             messiaen7:          [1, 1, 1, 2, 1, 1, 1, 1, 2, 1],
             super_locrian:      [1, 2, 1, 2, 2, 2, 2],
             hirajoshi:          [2, 1, 4, 1, 4],
             kumoi:              [2, 1, 4, 2, 3],
             neapolitan_major:   [1, 2, 2, 2, 2, 2, 1],
             bartok:             [2, 2, 1, 2, 1, 2, 2],
             bhairav:            [1, 3, 1, 2, 1, 3, 1],
             locrian_major:      [2, 2, 1, 1, 2, 2, 2],
             ahirbhairav:        [1, 3, 1, 2, 2, 1, 2],
             enigmatic:          [1, 3, 2, 2, 2, 1, 1],
             neapolitan_minor:   [1, 2, 2, 2, 1, 3, 1],
             pelog:              [1, 2, 4, 1, 4],
             augmented2:         [1, 3, 1, 3, 1, 3],
             scriabin:           [1, 3, 3, 2, 3],
             harmonic_major:     [2, 2, 1, 2, 1, 3, 1],
             melodic_minor_desc: [2, 1, 2, 2, 1, 2, 2],
             romanian_minor:     [2, 1, 3, 1, 2, 1, 2],
             hindu:              [2, 2, 1, 2, 1, 2, 2],
             iwato:              [1, 4, 1, 4, 2],
             melodic_minor:      [2, 1, 2, 2, 2, 2, 1],
             diminished2:        [2, 1, 2, 1, 2, 1, 2, 1],
             marva:              [1, 3, 2, 1, 2, 2, 1],
             melodic_major:      [2, 2, 1, 2, 1, 2, 2],
             indian:             [4, 1, 2, 3, 2],
             spanish:            [1, 3, 1, 2, 1, 2, 2],
             prometheus:         [2, 2, 2, 5, 1],
             diminished:         [1, 2, 1, 2, 1, 2, 1, 2],
             todi:               [1, 2, 3, 1, 1, 3, 1],
             leading_whole:      [2, 2, 2, 2, 2, 1, 1],
             augmented:          [3, 1, 3, 1, 3, 1],
             purvi:              [1, 3, 2, 1, 1, 3, 1],
             chinese:            [4, 2, 1, 4, 1],
             lydian_minor:       [2, 2, 2, 1, 1, 2, 2]}

  def new(intervals) when is_list(intervals) do
    [[0], intervals]
    |> Stream.concat()
    |> Stream.drop(-1)
    |> Enum.scan(&(&1 + &2))
    |> :erlang.list_to_tuple()
    |> new()
  end
  def new(positions) when is_tuple(positions) do
    %Musix.Scale{positions: positions}
  end

  for {name, seq} <- scales do
    def new(unquote(name)) do
      %Musix.Scale{
        name: unquote(name),
        positions: unquote(
          [[0], seq]
          |> Stream.concat()
          |> Stream.drop(-1)
          |> Enum.scan(&(&1 + &2))
          |> :erlang.list_to_tuple()
          |> Macro.escape()
        )
      }
    end

    def unquote(name)() do
      new(unquote(name))
    end
  end

  for offset <- 0..999 do
    degree_bin = RomanNumerals.encode(offset + 1)
    lower_bin = degree_bin |> String.downcase()
    values = [
      degree_bin,
      degree_bin |> String.to_atom(),
      lower_bin,
      lower_bin |> String.to_atom()
    ]
    def position(scale, degree) when degree in unquote(values) do
      position(scale, unquote(offset))
    end
  end
  def position(scale, degree) when is_binary(degree) do
    offset = (degree |> String.upcase |> RomanNumerals.decode) + 1
    position(scale, offset)
  end

  def position(%{positions: positions}, offset) when is_integer(offset) do
    size = tuple_size(positions)

    i = offset
    |> rem(size)
    |> abs()

    elem(positions, i) + (12 * div(offset, size))
  end

  def size(%{positions: positions}) do
    tuple_size(positions)
  end

  def list() do
    unquote(Map.keys(scales))
  end

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(%{name: name}, _opts) when not is_nil(name) do
      "#Musix.Scale<#{name}>"
    end
    def inspect(%{positions: positions}, opts) do
      concat([
        "#Musix.Scale<",
        positions
          |> Enum.scan(&(&2 - &1))
          |> @protocol.inspect(opts),
        ">"
      ])
    end
  end
end

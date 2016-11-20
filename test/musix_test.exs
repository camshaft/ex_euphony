defmodule Test.Musix do
  use ExUnit.Case

  import Musix

  @degrees [:i, :ii, :iii, :iv, :v, :vi, :vii]

  # test "generate song" do
  #   root = Musix.ChromaticNote.list() |> Enum.shuffle() |> Enum.take(1) |> hd()
  #
  #   count = 6
  #
  #   degrees = 1..count |> Enum.map(fn(_) -> gen_degree() end) |> gen_event(:degree) |> hseq()
  #
  #   rhythm = 1..count |> Enum.map(fn(_) -> gen_duration() end) |> gen_event(:duration) |> hseq()
  #
  #   motive = degrees |> unify(rhythm)
  #
  #   Musix.Scale.list()
  #   |> Enum.shuffle()
  #   |> Enum.take(2)
  #   |> Enum.map(fn(name) ->
  #     motive |> cascade(key: key(root, name))
  #   end)
  #   |> repeat(4)
  #   |> hseq()
  #   |> cascade(bpm: 180)
  #   |> prepare()
  #   |> play()
  # end

  defp gen_duration() do
    den = :math.pow(2, :rand.uniform(4)) |> trunc()
    num = :rand.uniform(den - 1)
    {num, den}
  end

  defp gen_degree() do
    @degrees
    |> Enum.shuffle()
    |> hd()
  end

  defp prepare(seq) do
    seq
    |> apply_cascade()
    |> sequence()
    |> Enum.to_list()
  end

  defp dup_values(stream) do
    stream
    |> Stream.flat_map(&[&1, &1])
  end

  defp gen_event(stream, key) do
    stream
    |> Stream.map(&event(%{key => &1}))
  end

  defp play(%{props: %{duration_ps: duration, note: %{position: p, octave: o}}} = event) do
    inspect_event(event)
    pitch = (o - 5) * 12 + (p + 3)
    duration = (duration / 1.5e12) |> to_string()
    args = ["-V1", "-qn", "synth", duration, "pluck", "%#{pitch}"]
    # |> IO.inspect
    System.cmd("play", args)
  end
  defp play(%{props: %{duration: _, degree: d, key: k} = props} = event) do
    %{event | props: Map.merge(props, %{
      duration_ps: props[:duration_ps] || Musix.Duration.to_picosecond(put_in(event, [:bpm], 150)),
      note: Musix.Key.position(k, d)
    })}
    |> play()
  end
  defp play(%{props: %{duration: _} = props} = event) do
    %{event | props: Map.merge(props, %{
      duration_ps: props[:duration_ps] || Musix.Duration.to_picosecond(put_in(event, [:bpm], 150)),
      # note: Musix.Key.position(k, d)
    })}
    |> play()
  end
  defp play([note, [num, den]]) do
    %{note: Musix.ChromaticNote.new(note),
      duration: {num, den}, bpm: 150}
    |> event()
    |> play()
  end
  defp play(stream) when is_list(stream) do
    stream
    |> Enum.each(&play/1)
  end

  defp inspect_event(%{props: %{note: note, duration: {num, den}}}) do
    IO.puts inspect([to_string(note), [num, den]], charlists: :as_lists) <> ","
  end
end

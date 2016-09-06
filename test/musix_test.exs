defmodule Test.Musix do
  use ExUnit.Case

  import Musix

  test "game of thrones" do
    root = -(4 * 12) + 2
    major = %Musix.Key{root: root, scale: :major}
    minor = %Musix.Key{root: root, scale: :minor}

    motive_degrees = [:v, :i, :iii, :iv] |> gen_event(:degree) |> hseq()

    motive_rhythm_1 = [16, 16, 8, 8] |> gen_event(:duration_64) |> hseq()
    motive_rhythm_2 = [48, 8, 32, 8] |> dup_values() |> gen_event(:duration_64) |> hseq()

    motive_1 = motive_degrees |> unify(motive_rhythm_1)
    motive_2 = motive_degrees |> repeat() |> unify(motive_rhythm_2)

    seq1 = motive_1 |> repeat(4) |> octave(5) |> apply_key(minor)
    seq2 = motive_1 |> repeat(4) |> octave(5) |> apply_key(major)
    seq3 = motive_2 |> octave(4) |> apply_key(minor)
    seq4 = motive_1 |> repeat(4) |> octave(4) |> apply_key(%{minor | root: root - 5})

    [seq1, seq2, seq3, seq4]
    |> Stream.concat()
    |> play()
  end

  defp octave(stream, octave) do
    stream
    |> Stream.map(&put_in(&1, [:octave], octave))
  end

  defp apply_key(stream, key) do
    stream
    |> Stream.map(&Musix.Key.degree_to_pitch(key, &1))
  end

  defp dup_values(stream) do
    stream
    |> Stream.flat_map(&[&1, &1])
  end

  defp gen_event(stream, key) do
    stream
    |> Enum.map(&event(%{key => &1}))
  end

  defp play(%{props: %{duration_64: duration, pitch: pitch}} = event) do
    IO.inspect event
    args = ["-V1", "-qn", "synth", inspect(duration / 64), "sine", "%#{pitch}"]
    System.cmd("play", args)
  end
  defp play(stream) do
    stream
    |> Enum.each(&play/1)
  end
end

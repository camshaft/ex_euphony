defmodule Test.Musix.Chord do
  use ExUnit.Case

  alias Musix.Chord

  test "major" do
    [0, 4, 7] = Chord.degrees(:triad) |> Enum.map(&Musix.Scale.position(:major, &1))
  end
end

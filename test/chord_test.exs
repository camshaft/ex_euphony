defmodule Test.Euphony.Chord do
  use Test.Euphony.Case

  test "major" do
    [0, 4, 7] = Chord.degrees(:triad) |> Enum.map(&Euphony.Scale.position(:major, &1))
  end
end

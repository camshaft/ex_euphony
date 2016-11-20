defmodule Test.Musix.Chord do
  use ExUnit.Case

  alias Musix.Chord

  test "major" do
    %{positions: {0, 4, 7}} = Chord.new(:major)
  end

  test "custom" do
    %{positions: {1, 2, 3}} = Chord.new({1, 2, 3})
  end
end

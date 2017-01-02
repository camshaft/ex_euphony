defmodule Test.Euphony.Duration do
  use Test.Euphony.Case
  alias Euphony.Duration

  test ":duration_ps" do
    assert 123 = event(%{duration_s: 123}) |> Duration.to_seconds()
  end

  test "duration: 1/4" do
    assert 1 / 2 == event(%{duration: 1 / 4}) |> Duration.to_seconds()
  end

  test "duration: 1/8" do
    assert 1 / 4 == event(%{duration: 1 / 8}) |> Duration.to_seconds()
  end

  test "duration: 3/8" do
    assert 3 / 4 == event(%{duration: 3 / 8}) |> Duration.to_seconds()
  end

  test "duration: 1/4, :bpm" do
    assert 3 / 5 == event(%{duration: 1 / 4, tempo: 100}) |> Duration.to_seconds()
  end
end

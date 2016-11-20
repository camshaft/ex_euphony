defmodule Test.Musix.Duration do
  use ExUnit.Case

  import Musix
  alias Musix.Duration

  test ":duration_ps" do
    assert 123 = event(%{duration_ps: 123}) |> Duration.to_picosecond()
  end

  test "duration: 1/4" do
    assert 500_000_000_000 = event(%{duration: {1, 4}}) |> Duration.to_picosecond()
  end

  test "duration: 1/8" do
    assert 250_000_000_000 = event(%{duration: {1, 8}}) |> Duration.to_picosecond()
  end

  test "duration: 3/8" do
    assert 750_000_000_000 = event(%{duration: {3, 8}}) |> Duration.to_picosecond()
  end

  test "duration: 1/4, :bpm" do
    assert 600_000_000_000 = event(%{duration: {1, 4}, bpm: 100}) |> Duration.to_picosecond()
  end
end

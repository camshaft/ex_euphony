defmodule Test.Euphony.Scale do
  use Test.Euphony.Case

  alias Euphony.Scale

  test "major degrees" do
    scale = :major
    assert 0  == scale |> Scale.position(:i)
    assert 2  == scale |> Scale.position(:ii)
    assert 4  == scale |> Scale.position(:iii)
    assert 5  == scale |> Scale.position(:iv)
    assert 7  == scale |> Scale.position(:v)
    assert 9  == scale |> Scale.position(:vi)
    assert 11 == scale |> Scale.position(:vii)
    assert 12 == scale |> Scale.position(:viii)
  end

  test "major offset" do
    scale = :major
    assert 0  == scale |> Scale.position(0)
    assert 2  == scale |> Scale.position(1)
    assert 4  == scale |> Scale.position(2)
    assert 5  == scale |> Scale.position(3)
    assert 7  == scale |> Scale.position(4)
    assert 9  == scale |> Scale.position(5)
    assert 11 == scale |> Scale.position(6)
    assert 12 == scale |> Scale.position(7)
  end

  # TODO test/fix negative offsets
end

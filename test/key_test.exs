defmodule Test.Musix.Key do
  use ExUnit.Case

  import Musix
  alias Musix.{ChromaticNote,Key}

  test "C major" do
    key = key(:C, :major)
    assert ChromaticNote.new(:C)  == key |> Key.position(:i)
    assert ChromaticNote.new(:D)  == key |> Key.position(:ii)
    assert ChromaticNote.new(:E)  == key |> Key.position(:iii)
    assert ChromaticNote.new(:F)  == key |> Key.position(:iv)
    assert ChromaticNote.new(:G)  == key |> Key.position(:v)
    assert ChromaticNote.new(:A)  == key |> Key.position(:vi)
    assert ChromaticNote.new(:B)  == key |> Key.position(:vii)
    assert ChromaticNote.new(:C5) == key |> Key.position(:viii)
  end

  test "C minor" do
    key = key(:C, :minor)
    assert ChromaticNote.new(:C)  == key |> Key.position(:i)
    assert ChromaticNote.new(:D)  == key |> Key.position(:ii)
    assert ChromaticNote.new(:Eb) == key |> Key.position(:iii)
    assert ChromaticNote.new(:F)  == key |> Key.position(:iv)
    assert ChromaticNote.new(:G)  == key |> Key.position(:v)
    assert ChromaticNote.new(:Ab) == key |> Key.position(:vi)
    assert ChromaticNote.new(:Bb) == key |> Key.position(:vii)
    assert ChromaticNote.new(:C5) == key |> Key.position(:viii)
  end
end

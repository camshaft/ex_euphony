defmodule Test.Musix.ChromaticNote do
  use ExUnit.Case

  alias Musix.ChromaticNote, as: Note

  test ":C" do
    assert %{position: 0, octave: 4} = Note.new(:C)
  end

  test ":D3" do
    assert %{position: 2, octave: 3} = Note.new(:D3)
  end

  test ":e3" do
    assert %{position: 4, octave: 3} = Note.new(:e3)
  end

  test "14" do
    assert %{position: 2, octave: 1} = Note.new(14)
  end

  test "-14" do
    assert %{position: 10, octave: -2} = Note.new(-14)
  end
end

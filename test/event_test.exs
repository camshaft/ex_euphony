defmodule Test.Musix.Event do
  use ExUnit.Case

  import Musix

  test "access" do
    event = event(%{foo: 1})
    assert 1 = event[:foo]
    assert %{props: %{bar: 2}} = put_in(event, [:bar], 2)
  end
end

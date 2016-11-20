defmodule Test.Musix.Cascadable do
  use ExUnit.Case

  import Musix

  test "cascade" do
    events = hseq([
      vseq([
        event(%{bar: 1})
      ]),
      event(%{}),
      event(%{foo: 1})
    ])
    |> cascade(%{bar: 2})
    |> apply_cascade()
    |> sequence()

    assert [%{bar: 1}, %{bar: 2}, %{bar: 2, foo: 1}] = events |> Enum.map(&(&1.props))
  end
end

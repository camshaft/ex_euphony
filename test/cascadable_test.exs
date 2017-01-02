defmodule Test.Euphony.Cascadable do
  use Test.Euphony.Case

  test "cascade" do
    events = hseq([
      vseq([
        event(%{bar: 1})
      ]),
      event(%{}),
      event(%{foo: 1})
    ])
    |> cascade(%{bar: 2})
    |> sequence()

    assert [%{bar: 1}, %{bar: 2}, %{bar: 2, foo: 1}] = events |> Enum.map(&(&1.props))
  end
end

defmodule Test.Euphony.Sequence do
  use Test.Euphony.Case

  opposites = %{hseq: :vseq, vseq: :hseq}

  for name <- Map.keys(opposites) do
    test "#{name} unify" do
      value = event()
      |> repeat(2)
      |> hseq()
      |> unify(%{foo: 123})
      |> Map.get(:elements)
      |> Enum.to_list()

      assert value == [event(foo: 123), event(foo: 123)]
    end
  end
end

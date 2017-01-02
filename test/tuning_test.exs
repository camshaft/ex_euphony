defmodule Test.Euphony.Tuning do
  use Test.Euphony.Case

  test "to_freq/3" do
    Euphony.Tuning.db()
    |> Stream.map(&elem(&1, 0))
    |> Enum.each(fn(name) ->
      Enum.each(-100..200, fn(i) ->
        name
        |> Euphony.Tuning.to_freq(440, i)
        |> Numbers.to_float()
      end)
    end)
  end
end

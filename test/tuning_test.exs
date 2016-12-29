defmodule Test.Musix.Tuning do
  use ExUnit.Case

  test "to_freq/3" do
    Musix.Tuning.db()
    |> Stream.map(&elem(&1, 0))
    |> Enum.each(fn(name) ->
      Enum.each(-100..200, fn(i) ->
        name
        |> Musix.Tuning.to_freq(440, i)
        |> Numbers.to_float()
      end)
    end)
  end
end

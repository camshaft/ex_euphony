defmodule Test.Euphony.Case do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Euphony
    end
  end
end

ExUnit.start()

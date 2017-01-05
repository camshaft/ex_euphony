defmodule Test.Euphony.Case do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Euphony
    end
  end
end

# This starts the multix cache
# TODO have multix be better about its cache
Euphony.Math.add(1,1)

ExUnit.start()

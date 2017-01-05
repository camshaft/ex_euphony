defmodule Euphony.Frequency do
  use Multix

  defmulti to_freq(value)
end

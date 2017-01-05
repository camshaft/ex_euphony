defmodule Euphony.Duration do
  use Multix

  defmulti to_seconds(value)
end

use Multix

defmodule Euphony.Math do
  import Kernel, except: [div: 2]

  defmodule Compat do
    methods = [
      add: :+,
      sub: :-,
      mult: :*,
      div: :/
    ]
    for {to, from} <- methods do
      defmacro unquote(from)(a, b) do
        {{:., [], [Euphony.Math, unquote(to)]}, [], [a, b]}
      end
    end
  end

  defmacro __using__(_) do
    quote do
      import Kernel, except: [+: 2, -: 2, *: 2, /: 2]
      import unquote(__MODULE__).Compat
    end
  end

  defmulti add(a, b)
  defmulti add(a, b) when is_number(a) and is_number(b) do
    a + b
  end

  defmulti sub(a, b)
  defmulti sub(a, b) when is_number(a) and is_number(b) do
    a - b
  end

  defmulti mult(a, b)
  defmulti mult(a, b) when is_number(a) and is_number(b) do
    a * b
  end
  defmulti mult(%Ratio{} = a, b) do
    Ratio.mult(a, b)
  end
  defmulti mult(a, %Ratio{} = b) do
    Ratio.mult(a, b)
  end

  defmulti div(a, b)
  defmulti div(a, b) when is_integer(a) and is_integer(b) do
    Ratio.div(a, b)
  end
  defmulti div(a, b) when is_number(a) and is_number(b) do
    case a / b do
      v when v == trunc(v) ->
        trunc(v)
      v ->
        v
    end
  end
  defmulti div(%Ratio{} = a, b) do
    Ratio.div(a, b)
  end
  defmulti div(a, %Ratio{} = b) do
    Ratio.div(a, b)
  end
end

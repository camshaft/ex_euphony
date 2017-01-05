use Multix

defmodule Euphony.Math do
  import Kernel, except: [div: 2]

  methods = [
    add: :+,
    sub: :-,
    mult: :*,
    div: :/
  ]

  defmodule Compat do
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

  for {call, op} <- Keyword.delete(methods, :div) do
    defmulti unquote(call)(a, b)
    defmulti unquote(call)(a, b) when is_number(a) and is_number(b) do
      Kernel.unquote(op)(a, b)
    end
    defmulti unquote(call)(%Ratio{} = a, b) do
      Ratio.unquote(call)(a, b)
    end
    defmulti unquote(call)(a, %Ratio{} = b) do
      Ratio.unquote(call)(a, b)
    end
  end

  defmulti div(a, b)
  defmulti div(a, b) when is_integer(a) and is_integer(b) do
    Ratio.div(a, b) |> force_ratio()
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
    Ratio.div(a, b) |> force_ratio()
  end
  defmulti div(a, %Ratio{} = b) do
    Ratio.div(a, b) |> force_ratio()
  end

  defp force_ratio(%Ratio{} = r), do: r
  defp force_ratio(n), do: %Ratio{numerator: n, denominator: 1}

  defmulti to_float(a)
  defmulti to_float(a) when is_number(a) do
    a
  end
  defmulti to_float(%Ratio{} = r) do
    Ratio.to_float(r)
  end

  defmulti to_integer(a)
  defmulti to_integer(a) when is_number(a) do
    trunc(a)
  end
  defmulti to_integer(r), priority: -1 do
    r
    |> to_float()
    |> to_integer()
  end
end

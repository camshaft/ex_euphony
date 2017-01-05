defmodule Nile.Random do
  def seed() do
    :rand.seed(:exsplus, :os.timestamp())
  end

  def seed(value) do
    :rand.seed(:exsplus, gen_seed(value))
  end

  def sample(items) do
    if !Process.get(:rand_seed), do: seed()
    %Stream{
      enum: Stream.repeatedly(sample_fun(items))
    }
  end

  def pick(stream) do
    stream
    |> Enum.take(1)
    |> hd()
  end

  def sample_statem(statem) do
    sample_statem(statem, sample_fun(Map.keys(statem)))
  end
  def sample_statem(statem, init_fun) when is_function(init_fun, 0) do
    statem = Enum.reduce(statem, %{}, fn
      ({state, %{__struct__: _} = struct}, acc) ->
        Map.put(acc, state, struct)
      ({state, stream}, acc) when is_function(stream, 2) ->
        Map.put(acc, state, stream)
      ({state, weighted}, acc) when is_map(weighted) ->
        Map.put(acc, state, sample_weighted(weighted))
      ({state, transitions}, acc) ->
        # TODO assert that all of the transitions exist
        case Map.fetch(statem, transitions) do
          {:ok, _} ->
            # If it's a key then we always make the transition
            Map.put(acc, state, Stream.repeatedly(fn -> transitions end))
          _ ->
            Map.put(acc, state, sample(transitions))
        end
    end)

    Stream.resource(
      fn -> {:init, init_fun.(), statem} end,
      &statem_next/1,
      fn(_) -> :ok end
    )
  end
  def sample_statem(statem, init) do
    case Map.fetch(statem, init) do
      {:ok, _} ->
        sample_statem(statem, fn -> init end)
      _ ->
        sample_statem(statem, sample_fun(init))
    end
  end

  defp statem_next({:init, init, acc}) do
    {[init], {:cont, init, acc}}
  end
  defp statem_next({:cont, prev, acc}) do
    {:ok, stream} = Map.fetch(acc, prev)
    case Nile.Utils.next(stream) do
      {status, _} when status in [:done, :halted] ->
        {:halt, nil}
      {:suspended, next, stream} ->
        acc = Map.put(acc, prev, stream)
        {[next], {:cont, next, acc}}
    end
  end

  def sample_weighted(items) do
    # TODO make this more efficient: don't create a massive tuple
    items
    |> Stream.flat_map(fn({value, times}) ->
      fn -> value end
      |> Stream.repeatedly()
      |> Stream.take(times)
    end)
    |> sample()
  end

  def uniq_window(stream, size \\ 1, max_resamples \\ 100) when size > 0 do
    %Stream{
      enum: Stream.transform(stream, {[], 0}, fn
        (_value, {_, ^max_resamples}) ->
          raise ArgumentError, "Unique window of size #{size} not satisfied after #{max_resamples} resamples"
        (value, {window, _skipped} = state) ->
          compute_window(window, value, size, [], state)
      end)
    }
  end

  defp compute_window(_, value, 0, acc, _state) do
    {[value], {[value | :lists.reverse(tl(acc))], 0}}
  end
  defp compute_window([], value, _, acc, _) do
    {[value], {[value | :lists.reverse(acc)], 0}}
  end
  defp compute_window([value | _rest], value, _size, _acc, {prev, skipped}) do
    {[], {prev, skipped + 1}}
  end
  defp compute_window([prev | rest], value, size, acc, state) do
    compute_window(rest, value, size - 1, [prev | acc], state)
  end

  defp gen_seed(value) do
    <<
      a :: size(54),
      b :: size(53),
      c :: size(53)
    >> = :crypto.hash(:sha, :erlang.term_to_binary(value))
    {a, b, c}
  end

  defp sample_fun({}) do
    raise ArgumentError, "cannot sample from an empty set"
  end
  defp sample_fun(items) when is_tuple(items) do
    size = tuple_size(items)
    fn ->
      elem(items, :rand.uniform(size) - 1)
    end
  end
  defp sample_fun(items) when is_list(items) do
    items
    |> :erlang.list_to_tuple()
    |> sample_fun()
  end
  defp sample_fun(enum) do
    enum
    |> Enum.to_list()
    |> sample_fun()
  end
end







defmodule Nile.Utils do
  @doc """
  Fetch the next item in a stream. This will consume a single item at a time.
  """
  def next(nil) do
    {:done, nil}
  end
  def next({:__SUSPENDED__, reducer}) when is_function(reducer) do
    {:cont, []}
    |> reducer.()
    |> wrap_cont()
  end
  def next(reducer) when is_function(reducer) do
    {:cont, []}
    |> reducer.(fn(value, _) -> {:suspend, value} end)
    |> wrap_cont()
  end
  def next(stream) do
    stream
    |> Enumerable.reduce({:cont, []}, fn(value, _) -> {:suspend, value} end)
    |> wrap_cont()
  end

  defp wrap_cont({:suspended, value, stream}) do
    {:suspended, value, {:__SUSPENDED__, stream}}
  end
  defp wrap_cont(other) do
    other
  end
end

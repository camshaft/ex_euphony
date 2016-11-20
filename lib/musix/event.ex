defmodule Musix.Event do
  defstruct [props: %{}]

  @behaviour Access
  def fetch(%{props: props}, key) do
    Map.fetch(props, key)
  end

  def get(%{props: props}, key, default) do
    Map.get(props, key, default)
  end

  def get_and_update(point = %{props: props}, key, value) do
    {value, props} = Map.get_and_update(props, key, value)
    {value, %{point | props: props}}
  end

  def pop(point = %{props: props}, key) do
    {value, props} = Map.pop(props, key)
    {value, %{point | props: props}}
  end
end

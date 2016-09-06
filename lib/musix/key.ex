defmodule Musix.Key do
  defstruct [root: 0,
             scale: :major]

  alias Musix.Scale

  def degree_to_pitch(key, %Musix.Event{props: %{degree: degree} = props} = event) do
    octave = Map.get(props, :octave, 0)
    pitch = degree_to_pitch(key, degree) + (octave * 12)
    %{event | props: Map.put(props, :pitch, pitch)}
  end
  def degree_to_pitch(%{root: root, scale: scale}, degree) when is_atom(degree) or is_integer(degree) do
    root + Scale.scale_interval(scale, degree)
  end
end

defmodule Euphony.Mixfile do
  use Mix.Project

  def project do
    [app: :euphony,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     compilers: Mix.compilers,
     deps: deps()]
  end

  def application do
    [applications: [:logger, :ratio, :roman_numerals]]
  end

  defp deps do
    [{:ratio, "~> 1.2.0"},
     {:multix, github: "camshaft/multix"},
     {:roman_numerals, "~> 1.0"}]
  end
end

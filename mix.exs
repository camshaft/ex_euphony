defmodule Musix.Mixfile do
  use Mix.Project

  def project do
    [app: :musix,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     compilers: Mix.compilers ++ [:multix],
     deps: deps()]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [{:decimal, "~> 1.0"},
     {:multix, github: "camshaft/multix"},
     {:roman_numerals, "~> 1.0"}]
  end
end

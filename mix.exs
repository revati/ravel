defmodule Ravel.Mixfile do
  use Mix.Project

  def project do
    [app: :ravel,
     version: "0.0.1",
     elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     package: package,
     description: "Extendable validation for Elixir",
     deps: deps]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [{:earmark, "~> 0.1", only: :dev},
     {:ex_doc, "~> 0.11", only: :dev}]
  end

  defp package do
    [maintainers: ["Roberts Gulans"],
     licenses: ["MIT"],
     links: %{github: "https://github.com/revati/ravel"},
     files: ~w(lib) ++
       ~w(LICENSE.md mix.exs README.md)]
  end

end

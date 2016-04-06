defmodule Ravel.Mixfile do
  use Mix.Project

  @name          "Ravel"
  @version        "0.0.4"
  @docs_url       "http://hexdocs.pm/ravel"
  @repository_url "https://github.com/revati/ravel"

  def project do
    [
      app:             :ravel,
      version:         @version,
      elixir:          "~> 1.1",
      build_embedded:  Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      package:         package,
      description:     "Extendable validation for Elixir",
      deps:            deps,
      name:            @name,
      test_coverage:   [tool: ExCoveralls],
      docs: [
        source_ref: "v#{@version}",
        main:       @name,
        canonical:  @docs_url,
        source_url: @repository_url
      ]
    ]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:excoveralls, "~> 0.5.1", only: [:dev, :test]},
      {:ex_doc,      "~> 0.11.4", only: :docs},
      {:earmark,     "~> 0.2.1", only: :docs},
      {:inch_ex,     "~> 0.5.1", only: :docs}
    ]
  end

  defp package do
    [
      maintainers: ["Roberts Gulans"],
      licenses:    ["MIT"],
      links:       %{github: @repository_url},
      files:       ~w(lib) ++ ~w(LICENSE.md mix.exs README.md)
    ]
  end

end

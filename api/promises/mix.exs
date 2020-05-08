defmodule Promises.MixProject do
  use Mix.Project

  def project do
    [
      app: :promises,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :mongodb, :poolboy],
      mod: {Promises.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug_cowboy, "~> 2.0"},
      {:jason, "~> 1.2"},
      {:mongodb, "~> 0.5.1"},
      {:poolboy, "~> 1.5.2"},
      {:httpoison, "~> 1.6"}
    ]
  end
end

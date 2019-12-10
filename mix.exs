defmodule Upclid.MixProject do
  use Mix.Project

  def project do
    [
      app: :upclid,
      version: "0.2.6",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: [
        upclid: [
          include_executables_for: [:unix],
          config_providers: [
            {TomlConfigProvider, path: "/etc/upclid.toml"}
          ]
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Upclid.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.0"},
      {:poison, "~> 3.1"},
      {:toml_config, "~> 0.1"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end
end

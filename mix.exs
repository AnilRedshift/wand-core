defmodule WandCore.MixProject do
  use Mix.Project

  @version "0.2.1"
  @description "Global tasks for interacting with wand"
  @cli_env [
    coveralls: :test,
    "coveralls.detail": :test,
    "coveralls.post": :test,
    "coveralls.html": :test
  ]

  def project do
    [
      aliases: aliases(),
      app: :wand_core,
      version: @version,
      description: @description,
      elixir: "~> 1.6",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: @cli_env,
      deps: deps(),
      package: package(),
      source_url: "https://github.com/AnilRedshift/wand-core",
      docs: [
        source_ref: "v#{@version}",
        main: "readme",
        extras: ["README.md"],
      ],
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp aliases do
    [
      build: [&build_archive/1]
    ]
  end

  defp build_archive(_) do
    Mix.Tasks.Compile.run([])
    Mix.Tasks.Archive.Build.run(["--output=wand.ez"])
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:excoveralls, "~> 0.9.1", only: :test},
      {:junit_formatter, "~> 2.2", only: :test},
      {:mox, "~> 0.3.2", only: :test}
    ]
  end

  defp elixirc_paths(:test), do: ["test/support", "lib"]
  defp elixirc_paths(_), do: ["lib"]

  defp package do
    [
      name: :wand_core,
      files: ["lib", "mix.exs"],
      maintainers: ["Anil Kulkarni"],
      licenses: ["BSD-3"],
      links: %{"Github" => "https://github.com/AnilRedshift/wand-core"}
    ]
  end
end

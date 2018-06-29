defmodule Wand.MixProject do
  use Mix.Project

  @version "0.2.0"
  @description "Global tasks for interacting with wand"

  def project do
    [
      aliases: aliases(),
      app: :wand_core,
      version: @version,
      description: @description,
      elixir: "~> 1.6",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp aliases do
    [
      build: [&build_archive/1],
    ]
  end
  defp build_archive(_) do
    Mix.Tasks.Compile.run([])
    Mix.Tasks.Archive.Build.run(["--output=wand.ez"])
    File.rename("wand.ez", "../wand-archive/wand.ez")
    File.cp("../wand-archive/wand.ez", "../wand-archive/wand-#{@version}.ez")
  end

  defp deps do
    [
      {:mox, "~> 0.3.2", only: :test},
      {:ex_doc, ">= 0.0.0", only: :dev},
    ]
  end

  defp elixirc_paths(:test), do: ["test/support", "lib"]
  defp elixirc_paths(_), do: ["lib"]

  defp package do
    [ name: :wand_core,
      files: ["lib", "mix.exs"],
      docs: [extras: ["README.md"]],
      maintainers: ["Anil Kulkarni"],
      licenses: ["BSD-3"],
      links: %{"Github" => "https://github.com/AnilRedshift/wand-core"},
    ]
  end
end

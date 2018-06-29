use Mix.Config

if Mix.env() == :test do
  config :wand_core,
    project: WandCore.ProjectMock
end

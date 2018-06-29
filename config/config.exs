use Mix.Config

if Mix.env() == :test do
  config :wand_core,
    file: WandCore.FileMock,
    project: WandCore.ProjectMock
end

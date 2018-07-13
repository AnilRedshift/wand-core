defmodule WandCore.WandFile do
  alias WandCore.WandFile
  alias WandCore.Interfaces.File
  @requirement "~> 1.0"
  @vsn "1.0.0"

  @moduledoc """
  Module describing the internal state of a wand file, along with helper functions to manipulate the dependencies and serialize the module to disk.

  ## Wand.json
  The format for wand.json looks like this:
  <pre>
  {
    "version": #{@vsn},
    "dependencies": {
      "dependency_name': dependency,
    }
  }
  </pre>

  A dependency can have the following serialized formats in wand.json:

  ### Simple dependency
  The value can be a string of the version requirement: `"poison": "~> 3.1.0"`.

  ### Dependency with just opts
  If, say, pulling from git, the value can be just a map of options: `"poison": {"git": "https://github.com/devinus/poison.git"}`

  ### Dependency with a version and opts
  Lastly, a dependency can be a list of `[requirement, opts]`. For example: `"poison": ["~> 3.1.0", {"only": ":test"}`
  """

  @type t :: %__MODULE__{
          version: String.t(),
          dependencies: %{optional(atom()) => WandCore.WandFile.Dependency.t()}
        }
  @type success :: {:ok, t}
  @type error :: {:error, any()}
  @type success_or_error :: success | error

  defstruct version: @vsn,
            dependencies: []

  defmodule Dependency do
    @type name :: String.t()
    @type requirement :: String.t() | nil
    @type source :: :hex | :git | :path
    @type t :: %__MODULE__{name: String.t(), requirement: requirement, opts: WandCore.Opts.t()}
    @enforce_keys [:name]
    @moduledoc """
    A dependency describes the information for a specific mix dependency, including its name, requirement string, and any options See `WandCore.WandFile` for more information.
    """
    defstruct name: nil, requirement: nil, opts: %{}

    @doc """
    Determine if the dependency is referring to a hex repository, a git repository, or a local path
    """
    @spec source(t) :: source
    def source(%Dependency{opts: opts}) do
      cond do
        Map.get(opts, :git) -> :git
        Map.get(opts, :path) -> :path
        Map.get(opts, :in_umbrella) -> :path
        true -> :hex
      end
    end
  end

  @doc """
  Add a new Dependency to a WandFile, unless the name already exists in the file
  """
  @spec add(t, Dependency.t()) :: success_or_error
  def add(%WandFile{} = file, %Dependency{} = dependency) do
    case exists?(file, dependency.name) do
      false ->
        file = update_in(file.dependencies, &[dependency | &1])
        {:ok, file}

      true ->
        {:error, {:already_exists, dependency.name}}
    end
  end

  @doc """
  Load a wand.json file from disk, and parse it into a WandFile
  """
  @spec load(Path.t()) :: success_or_error
  def load(path \\ "wand.json") do
    with {:ok, contents} <- read(path),
         {:ok, data} <- parse(contents),
         {:ok, wand_file} <- validate(data) do
      {:ok, wand_file}
    else
      error -> error
    end
  end

  @doc """
  Remove a dependency to a WandFile by name. Returns the file (always succeeds)
  """
  @spec remove(t, Dependency.name()) :: t
  def remove(%WandFile{} = file, name) do
    update_in(file.dependencies, fn dependencies ->
      Enum.reject(dependencies, &(&1.name == name))
    end)
  end

  @doc """
  Save the WandFile as a JSON file to the path indicated.
  """
  @spec save(t, Path.t()) :: :ok | error
  def save(%WandFile{} = file, path \\ "wand.json") do
    contents = WandCore.Poison.encode!(file, pretty: true)
    File.impl().write(path, contents)
  end

  defp validate(data) do
    with {:ok, version} <- validate_version(extract_version(data)),
         {:ok, dependencies} <- validate_dependencies(Map.get(data, :dependencies, %{})) do
      {:ok, %WandCore.WandFile{version: to_string(version), dependencies: dependencies}}
    else
      error -> error
    end
  end

  defp validate_dependencies(dependencies) when not is_map(dependencies),
    do: {:error, :invalid_dependencies}

  defp validate_dependencies(dependencies) do
    {dependencies, errors} =
      Enum.map(dependencies, fn
        {name, [requirement, opts]} ->
          create_dependency(name, requirement, opts)

        {name, [opts]} ->
          create_dependency(name, nil, opts)

        {name, requirement} ->
          create_dependency(name, requirement, %{})
      end)
      |> Enum.split_with(fn
        %Dependency{} -> true
        _ -> false
      end)

    case errors do
      [] -> {:ok, dependencies}
      [error | _] -> error
    end
  end

  defp validate_version({:error, _} = error), do: error

  defp validate_version({:ok, version}) do
    if Version.match?(version, @requirement) do
      {:ok, version}
    else
      {:error, :version_mismatch}
    end
  end

  defp extract_version(%{version: version}) when is_binary(version) do
    case Version.parse(version) do
      :error -> {:error, :invalid_version}
      {:ok, version} -> {:ok, version}
    end
  end

  defp extract_version(%{version: _}), do: {:error, :invalid_version}
  defp extract_version(_data), do: {:error, :missing_version}

  defp create_dependency(name, nil, opts) do
    name = to_string(name)
    opts = WandCore.Opts.decode(opts)
    %Dependency{name: name, opts: opts}
  end

  defp create_dependency(name, requirement, opts) do
    name = to_string(name)
    opts = WandCore.Opts.decode(opts)

    case Version.parse_requirement(requirement) do
      :error -> {:error, {:invalid_dependency, name}}
      _ -> %Dependency{name: name, requirement: requirement, opts: opts}
    end
  end

  defp exists?(%WandFile{dependencies: dependencies}, name) do
    Enum.find(dependencies, &(&1.name == name)) != nil
  end

  defp parse(contents) do
    case WandCore.Poison.decode(contents, keys: :atoms) do
      {:ok, data} -> {:ok, data}
      {:error, _reason} -> {:error, :json_decode_error}
    end
  end

  defp read(path) do
    case File.impl().read(path) do
      {:ok, contents} -> {:ok, contents}
      {:error, reason} -> {:error, {:file_read_error, reason}}
    end
  end
end

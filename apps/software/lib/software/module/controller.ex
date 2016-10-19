defmodule HELM.Software.Module.Controller do
  import Ecto.Query

  alias HELM.Software.Repo
  alias HELM.Software.Module.Schema, as: SoftModuleSchema

  def create(role, type, version) do
    %{module_role: role,
      file_type: type,
      module_version: version}
    |> SoftModuleSchema.create_changeset()
    |> Repo.insert()
  end

  def find(role, type) do
    case Repo.get_by(SoftModuleSchema, module_role: role, file_type: type) do
      nil -> {:error, :notfound}
      res -> {:ok, res}
    end
  end

  def delete(role, type) do
    case find(role, type) do
      {:ok, file} -> Repo.delete(file)
      error -> error
    end
  end
end
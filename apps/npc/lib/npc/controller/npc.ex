defmodule HELM.NPC.Controller.NPC do

  import Ecto.Query, only: [where: 3]

  alias HELM.NPC.Repo
  alias HELM.NPC.Model.NPC, as: MdlNPC

  def create(npc) do
    MdlNPC.create_changeset(npc)
    |> Repo.insert()
  end

  def find(npc_id) do
    case Repo.get(MdlNPC, npc_id) do
      nil -> {:error, :notfound}
      npc -> {:ok, npc}
    end
  end

  def delete(npc_id) do
    MdlNPC
    |> where([s], s.npc_id == ^npc_id)
    |> Repo.delete_all()

    :ok
  end
end
defmodule Helix.Network.Model.Link do

  use Ecto.Schema

  alias HELL.PK

  import Ecto.Changeset

  @primary_key false
  schema "links" do
    field :tunnel_id, PK,
      primary_key: true
    field :source_id, PK,
      primary_key: true

    field :destination_id, PK

    field :sequence, :integer
  end

  def create(source, destination, sequence) do
    params = %{
      source_id: source,
      destination_id: destination,
      sequence: sequence
    }

    %__MODULE__{}
    |> cast(params, [:source_id, :destination_id, :sequence])
    |> validate_required([:source_id, :destination_id, :sequence])
  end
end

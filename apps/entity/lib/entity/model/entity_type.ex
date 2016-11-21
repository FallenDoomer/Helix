defmodule HELM.Entity.Model.EntityType do

  use Ecto.Schema
  import Ecto.Changeset

  alias HELM.Entity.Model.Entity, as: MdlEntity, warn: false

  @type t :: %__MODULE__{}
  @type name :: String.t

  @primary_key {:entity_type, :string, autogenerate: false}
  @creation_fields ~w/entity_type/a

  schema "entity_types" do
    has_many :entities, MdlEntity,
      foreign_key: :entity_type,
      references: :entity_type
  end

  @spec create_changeset(%{entity_type: name}) :: Ecto.Changeset.t
  def create_changeset(params) do
    %__MODULE__{}
    |> cast(params, @creation_fields)
    |> validate_required(:entity_type)
    |> unique_constraint(:entity_type)
  end
end
defmodule Helix.Hardware.Model.MotherboardSlot do

  use Ecto.Schema

  alias HELL.PK
  alias Helix.Hardware.Model.Component
  alias Helix.Hardware.Model.ComponentType
  alias Helix.Hardware.Model.Motherboard

  import Ecto.Changeset

  @type t :: %__MODULE__{
    slot_id: PK.t,
    slot_internal_id: integer,
    motherboard: Motherboard.t,
    motherboard_id: PK.t,
    component: Component.t,
    link_component_id: PK.t,
    type: ComponentType.t,
    link_component_type: String.t,
    inserted_at: NaiveDateTime.t,
    updated_at: NaiveDateTime.t
  }

  @type creation_params :: %{
    :motherboard_id => PK.t,
    :link_component_type => String.t,
    :slot_internal_id => integer,
    optional(:link_component_id) => PK.t
  }
  @type update_params :: %{link_component_id: PK.t}

  @creation_fields ~w/
    motherboard_id
    link_component_type
    link_component_id
    slot_internal_id/a
  @update_fields ~w/link_component_id/a

  @primary_key false
  schema "motherboard_slots" do
    field :slot_id, HELL.PK,
      primary_key: true

    field :slot_internal_id, :integer

    belongs_to :motherboard, Motherboard,
      foreign_key: :motherboard_id,
      references: :motherboard_id,
      type: HELL.PK
    belongs_to :component, Component,
      foreign_key: :link_component_id,
      references: :component_id,
      type: HELL.PK
    belongs_to :type, ComponentType,
      foreign_key: :link_component_type,
      references: :component_type,
      type: :string

    timestamps()
  end

  @spec create_changeset(creation_params) :: Ecto.Changeset.t
  def create_changeset(params) do
    %__MODULE__{}
    |> cast(params, @creation_fields)
    |> validate_required(
      [:motherboard_id, :link_component_type, :slot_internal_id])
    |> put_primary_key()
  end

  @spec update_changeset(t | Ecto.Changeset.t, update_params) :: Ecto.Changeset.t
  def update_changeset(struct, params) do
    struct
    |> cast(params, @update_fields)
  end

  @spec put_primary_key(Ecto.Changeset.t) :: Ecto.Changeset.t
  defp put_primary_key(changeset) do
    if get_field(changeset, :slot_id) do
      changeset
    else
      pk = PK.generate([0x0003, 0x0002, 0x0000])
      cast(changeset, %{slot_id: pk}, [:slot_id])
    end
  end

  @spec linked?(t) :: boolean
  def linked?(%__MODULE__{link_component_id: nil}),
    do: false
  def linked?(%__MODULE__{link_component_id: _}),
    do: true
end
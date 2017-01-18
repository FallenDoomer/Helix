defmodule Helix.Hardware.Model.Component.HDD do

  use Ecto.Schema

  alias HELL.PK
  alias Helix.Hardware.Model.Component

  import Ecto.Changeset

  @type t :: %__MODULE__{
    hdd_id: PK.t,
    hdd_size: non_neg_integer,
    component: Component.t
  }

  @primary_key false
  schema "hdds" do
    field :hdd_id, PK,
      primary_key: true

    field :hdd_size, :integer

    belongs_to :component, Component,
      foreign_key: :hdd_id,
      references: :component_id,
      type: PK,
      define_field: false,
      on_replace: :delete
  end

  @spec create_changeset(%{any => any}) :: Ecto.Changeset.t
  def create_changeset(params) do
    %__MODULE__{}
    |> cast(params, [:hdd_id])
    |> changeset(params)
  end

  @spec update_changeset(t | Ecto.Changeset.t, %{any => any}) :: Ecto.Changeset.t
  def update_changeset(struct, params),
    do: changeset(struct, params)

  @spec changeset(t | Ecto.Changeset.t, %{any => any}) :: Ecto.Changeset.t
  def changeset(struct, params) do
    struct
    |> cast(params, [:hdd_size])
    |> validate()
    |> foreign_key_constraint(:hdd_id, name: :hdds_hdd_id_fkey)
  end

  @spec validate(Ecto.Changeset.t) :: Ecto.Changeset.t
  defp validate(changeset) do
    changeset
    |> validate_required([:hdd_size])
    |> validate_number(:hdd_size, greater_than_or_equal_to: 0)
  end

  defmodule Query do

    alias Helix.Hardware.Model.Component.HDD

    import Ecto.Query, only: [where: 3]

    @spec from_component_ids([HELL.PK.t]) :: Ecto.Queryable.t
    @spec from_component_ids(Ecto.Queryable.t, [HELL.PK.t]) :: Ecto.Queryable.t
    def from_component_ids(query \\ HDD, component_ids) do
      where(query, [h], h.hdd_id in ^component_ids)
    end
  end
end
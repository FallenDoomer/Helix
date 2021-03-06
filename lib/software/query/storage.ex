defmodule Helix.Software.Query.Storage do

  alias Helix.Hardware.Model.Component
  alias Helix.Software.Internal.Storage, as: StorageInternal
  alias Helix.Software.Model.Storage

  @spec fetch(Storage.id) ::
    Storage.t
    | nil
  defdelegate fetch(storage_id),
    to: StorageInternal

  @spec get_storage_from_hdd(Component.id) ::
    Storage.t
    | nil
  defdelegate get_storage_from_hdd(hdd_id),
    to: StorageInternal
end

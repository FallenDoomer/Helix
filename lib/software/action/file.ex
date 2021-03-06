defmodule Helix.Software.Action.File do

  alias Helix.Software.Internal.File, as: FileInternal
  alias Helix.Software.Model.File
  alias Helix.Software.Model.Storage

  @spec create(File.creation_params) ::
    {:ok, File.t}
    | {:error, Ecto.Changeset.t}
  defdelegate create(params),
    to: FileInternal

  @spec copy(File.t, Storage.t, path :: String.t) ::
    {:ok, File.t}
    | {:error, Ecto.Changeset.t}
  defdelegate copy(file, storage, path),
    to: FileInternal

  @spec move(File.t, path :: String.t) ::
    {:ok, File.t}
    | {:error, Ecto.Changeset.t}
  defdelegate move(file, path),
    to: FileInternal

  @spec rename(File.t, name :: String.t) ::
    {:ok, File.t}
    | {:error, Ecto.Changeset.t}
  defdelegate rename(file, name),
    to: FileInternal

  @spec encrypt(File.t, version :: pos_integer) ::
    {:ok, File.t}
    | {:error, Ecto.Changeset.t}
  defdelegate encrypt(file, version),
    to: FileInternal

  @spec decrypt(File.t) ::
    {:ok, File.t}
    | {:error, Ecto.Changeset.t}
  defdelegate decrypt(file),
    to: FileInternal

  @spec delete(File.t) ::
    :ok
  defdelegate delete(file),
    to: FileInternal
end

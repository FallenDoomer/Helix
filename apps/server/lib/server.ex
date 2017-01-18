defmodule Helix.Server.App do

  use Application

  alias Helix.Server.Controller.ServerService
  alias Helix.Server.Repo

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      worker(Repo, []),
      worker(ServerService, [])
    ]

    opts = [strategy: :one_for_one, name: Helix.Server.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
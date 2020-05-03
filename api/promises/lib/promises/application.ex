defmodule Promises.Application do

  use Application
  require Logger

  def start(_type, _args) do
    import Supervisor.Spec


    children = [
      {Plug.Cowboy, scheme: :http, plug: Endpoint, options: [port: cowboy_port()]},
      worker(Mongo, [[name: :database, database: database(), pool_size: 2]])
    ]

    opts = [strategy: :one_for_one, name: Promises.Supervisor]

    Logger.info "Starting server..."

    Supervisor.start_link(children, opts)
  end

  defp cowboy_port, do: Application.get_env(:promises, :port, 8000)

  defp database, do: Application.get_env(:promises, :database, "ipromise-promises")

end

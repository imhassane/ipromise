defmodule Promises.Application do

  use Application
  require Logger

  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: Router, options: [port: cowboy_port()]}
    ]

    opts = [strategy: :one_for_one, name: Promises.Supervisor]
    Logger.info "Starting server..."
    Supervisor.start_link(children, opts)
  end

  def cowboy_port, do: Application.get_env(:promises, :cowboy_port, 8000)
end

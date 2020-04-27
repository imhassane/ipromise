defmodule Router do
  use Plug.Router

  plug :match

  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)

  plug :dispatch

  get "/" do
    send_resp(conn, 200, "welcome")
  end

  match _ do
    send_resp(conn, 404, "oops!")
  end
end
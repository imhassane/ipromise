defmodule Router do
  use Plug.Router

  plug :match

  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)

  plug :dispatch

  get "/" do
    data = :database
    |> Mongo.find("promises", %{})
    |> Enum.to_list
    send_resp(conn, 200, data)
  end

  def "/create" do
    
  end

  match _ do
    send_resp(conn, 404, "oops!")
  end
end
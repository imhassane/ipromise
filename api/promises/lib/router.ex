defmodule Router do
  use Plug.Router

  alias Types.Promise

  plug(Plug.Logger)

  plug :match

  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)

  plug :dispatch

  get "/" do
    data = :database
    |> Mongo.find("promises", %{})
    |> Enum.to_list
    |> IO.inspect

    send_resp(conn, 200, "data")
  end

  get "/create" do
    p = Promise.new()
    data = p |> Jason.encode! |> Jason.decode!

    :database
    |> Mongo.insert_one("promises", data)

    send_resp(conn, 200, Jason.encode! data)
  end

  get "/delete" do
    :database |> Mongo.delete_many("promises", %{})
    send_resp(conn, 200, "deleted successfully")
  end

  match _ do
    send_resp(conn, 404, "oops!")
  end
end
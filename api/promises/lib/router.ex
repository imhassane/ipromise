defmodule Router do
  use Plug.Router

  alias Types.Promise
  alias Service.{PromiseService}

  plug(Plug.Logger)

  plug :match

  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)

  plug :dispatch

  get "/" do
    response = PromiseService.get_promises()

    handle_response(conn, response)
  end

  get "/create" do

    data = "{\"title\":\"Aller à la salle de sport\"}"
    %{"title" => title} = data |> Jason.decode!

    promise = Promise.new(title)
    response = promise |> PromiseService.add_promise()

    handle_response(conn, response)
  end

  get "/delete" do
    :database |> Mongo.delete_many("promises", %{})
    send_resp(conn, 200, "deleted successfully")
  end

  match _ do
    send_resp(conn, 404, "oops!")
  end

  defp handle_response(conn, response) do
    %{ code: code, message: message } =
      case response do
        {:ok, message} -> %{code: 200, message: message}
        {:malformed_data, message} -> %{code: 400, message: message}
        {_, message} -> %{code: 500, message: message}
      end

    send_resp(conn, code, message)
  end
end
defmodule Router do
  use Plug.Router

  alias Types.Promise
  alias Service.{PromiseService}

  plug(Plug.Logger)

  plug :match

  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)

  plug :dispatch

  get "/" do
    PromiseService.get_promises() |> handle_response(conn)
  end

  get "/details/:id" do
    PromiseService.get_promise(id) |> handle_response(conn)
  end

  get "/create" do

    data = "{\"title\":\"Aller à la salle de sport\"}"
    %{"title" => title} = data |> Jason.decode!

    promise = Promise.new(title)
    promise
      |> PromiseService.add_promise()
      |> handle_response(conn)
  end

  get "/delete/:id" do
    PromiseService.delete_promise(id)
    |> handle_response(conn)
  end

  match _ do
    send_resp(conn, 404, "oops!")
  end

  defp handle_response(response, conn) do
    %{ code: code, message: message } =
      case response do
        {:ok, message} -> %{code: 200, message: message}
        {:malformed_data, message} -> %{code: 400, message: message}
        {:not_found, message} -> %{code: 404, message: message}
        {_, message} -> %{code: 500, message: message}
      end

    send_resp(conn, code, message)
  end
end
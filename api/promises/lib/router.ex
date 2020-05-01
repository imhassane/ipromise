defmodule Router do
  use Plug.Router

  alias Service.{PromiseService, FrequencyService, TargetService}

  plug(Plug.Logger)

  plug :match

  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)

  plug :dispatch

  # Promise routes

  get "/" do
    PromiseService.get_promises() |> handle_response(conn)
  end

  get "/details/:id" do
    PromiseService.get_promise(id) |> handle_response(conn)
  end

  post "/create" do
    PromiseService.add_promise(conn.body_params)
    |> handle_response(conn)
  end

  put "/update/:id" do
    PromiseService.update_promise(id, conn.body_params)
    |> handle_response(conn)
  end

  delete "/delete/:id" do
    PromiseService.delete_promise(id)
    |> handle_response(conn)
  end

  # Frequency routes

  post "/frequency/create/:promise_id" do
    FrequencyService.add_frequency(promise_id, conn.body_params)
    |> handle_response(conn)
  end

  put "/frequency/update/:promise_id" do
    FrequencyService.update_frequency(promise_id, conn.body_params)
    |> handle_response(conn)
  end

  delete "/frequency/delete/:promise_id" do
    FrequencyService.delete_frequency(promise_id)
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
        {:error, message} -> %{code: 500, message: message}
        {_, _} -> %{code: 500, message: "An internal error occurred"}
      end

      # TODO: Adding logging for errors.
    message = Jason.encode! %{ data: message }
    send_resp(conn, code, message)
  end


end
defmodule Routes.PromiseRouter do
  use BaseRouter
  alias Service.PromiseService


  get "/" do
    PromiseService.get_promises() |> handle_response(conn)
  end

  get "/:id" do
    PromiseService.get_promise(id) |> handle_response(conn)
  end

  post "/" do
    PromiseService.add_promise(conn.body_params)
    |> handle_response(conn)
  end

  put "/:id" do
    PromiseService.update_promise(id, conn.body_params)
    |> handle_response(conn)
  end

  delete "/:id" do
    PromiseService.delete_promise(id)
    |> handle_response(conn)
  end

  def handle_response(response, conn) do
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
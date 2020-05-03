defmodule Routes.TargetRouter do
  use Plug.Router

  alias Service.TargetService

  plug :match

  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)

  plug :dispatch

  get "/:frequency_id" do
    TargetService.get_frequency_targets(frequency_id)
    |> handle_response(conn)
  end

  get "/details/:id" do
    TargetService.get_target(id)
    |> handle_response(conn)
  end

  post "/:frequency_id" do
    TargetService.add_target(frequency_id, conn.body_params)
    |> handle_response(conn)
  end

  put "/:id" do
    TargetService.update_target(id, conn.body_params)
    |> handle_response(conn)
  end

  delete "/:id" do
    TargetService.delete_target(id)
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
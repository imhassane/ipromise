defmodule Routes.FrequencyRouter do
  use BaseRouter
  alias Service.FrequencyService

  post "/:promise_id" do
    FrequencyService.add_frequency(promise_id, conn.body_params)
    |> handle_response(conn)
  end

  put "/:promise_id" do
    FrequencyService.update_frequency(promise_id, conn.body_params)
    |> handle_response(conn)
  end

  delete "/:promise_id" do
    FrequencyService.delete_frequency(promise_id)
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
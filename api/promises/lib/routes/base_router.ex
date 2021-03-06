defmodule BaseRouter do

  defmacro __using__([]) do
    quote do
      use Plug.Router

      plug :match
      plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
      plug :dispatch

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
        conn
            |> Plug.Conn.put_resp_content_type("application/json")
            |> send_resp(code, message)
      end
    end
  end
  
end
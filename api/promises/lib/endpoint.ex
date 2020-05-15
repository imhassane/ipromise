defmodule Endpoint do
  use Plug.Router
  use Plug.ErrorHandler

  alias Promises.Auth.AuthPlug

  plug(Plug.Logger)
  plug AuthPlug
  plug :match
  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
  plug :dispatch

  forward "/promises", to: Routes.PromiseRouter
  forward "/frequencies", to: Routes.FrequencyRouter
  forward "/targets", to: Routes.TargetRouter

  match _ do
    send_resp(conn, 404, "oops!")
  end

  defp handle_errors(conn, %{kind: _kind, reason: %{message: message}, stack: _stack}) do
    conn
      |> Plug.Conn.put_resp_content_type("application/json")
      |> send_resp(conn.status, Jason.encode!(%{data: message}))
  end

  defp handle_errors(conn, %{kind: _kind, reason: _reason, stack: _stack}) do
    conn
    |> Plug.Conn.put_resp_content_type("application/json")
    |> send_resp(conn.status, Jason.encode!(%{data: "An error occurred internally"}))
  end
end
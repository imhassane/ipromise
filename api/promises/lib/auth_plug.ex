defmodule Promises.Auth.AuthPlug do
  defmodule NonAuthenticatedError do
    @moduledoc """
    Error raised when the user is not authenticated
    """

    defexception message: "You need to be authenticated", code: 401
  end

  def init(options), do: options

  def call(conn, _) do
    verify_authentication(conn)
    conn
  end

  defp verify_authentication(conn) do
    is_authenticated =
      case HTTPoison.get "http://localhost:5000/api/v1/user/" do
        {:error, _} ->
          false
        {:ok, %HTTPoison.Response{body: body}} ->
          IO.inspect body
          true
          _ ->
          false
      end

    unless is_authenticated, do: raise(NonAuthenticatedError)
  end
end
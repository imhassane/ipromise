defmodule Promises.Auth.AuthPlug do
  defmodule NonAuthenticatedError do

    defexception message: "You need to be authenticated", code: 401
  end

  @url "http://localhost:5000/api/v1/user"

  def init(options), do: options

  def call(conn, _) do
    conn = verify_authentication(conn)
    conn
  end

  defp verify_authentication(%Plug.Conn{req_headers: headers} = conn) do
    {_, token} = get_authentication_token headers
    if !token do
      raise(NonAuthenticatedError)
    else
      headers = [
        {"content-type", "application/json"},
        {"authentication-token", token}
      ]
      case HTTPoison.get(@url, headers) do
        {:error, _} ->
          raise(NonAuthenticatedError)
        {:ok, %HTTPoison.Response{body: body}} ->
          conn = Plug.Conn.assign(conn, :user, Jason.decode!(body))
          conn
        _ ->
          raise(NonAuthenticatedError)
      end
    end

  end

  defp get_authentication_token(headers) do
    result = Enum.filter(headers, fn({name, _}) -> name == "authentication-token" end)
    if (Kernel.length result) == 0 do
      {"authentication-token", nil}
    else
      Kernel.hd result
    end
  end
end
defmodule Router.PromisesTest do
  use ExUnit.Case
  use Plug.Test

  alias Router

  @options Router.init([])

  test "get list of promises" do
    conn =
      :get
      |> conn("/", "")
      |> Router.call(@options)

      assert conn.state   == :sent
      assert conn.status  == 200
  end

  test "get a non valid promise" do
    conn =
      :get
      |> conn("/details/5ea72b266006b85047597b29", "")
      |> Router.call(@options)

      assert conn.state == :sent
      assert conn.status == 404
  end

  test "get a promise with an invalid argument" do
    conn =
      :get
      |> conn("/details/5ea72b266006", "")
      |> Router.call(@options)

    assert conn.state == :sent
    assert conn.status == 404
  end

  test "returns 404" do
    conn =
    :get
    |> conn("/missing", "")
    |> Router.call(@options)

    assert conn.state   == :sent
    assert conn.status  == 404
  end
end
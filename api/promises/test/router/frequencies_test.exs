defmodule Router.FrequenciesTest do
  use ExUnit.Case
  use Plug.Test

  alias Router

  @options Router.init([])

  # TODO: ajout des tests pour les requetes crud.

  test "Trying to add a frequency with non existant promise" do
    conn =
      :post
      |> conn("/frequency/create/abde", "")
      |> Router.call(@options)

    assert conn.state == :sent
    assert conn.status == 404
  end

  test "Trying to update a frequency with non valid id" do
    conn =
      :put
      |> conn("/frequency/update/abde", "")
      |> Router.call(@options)

    assert conn.state == :sent
    assert conn.status == 400
  end

  test "Trying to delete a non existant frequency" do
    conn =
      :delete
      |> conn("/frequency/delete/abde", "")
      |> Router.call(@options)

    assert conn.state == :sent
    assert conn.status == 404
  end

end
defmodule Router.TargetsTest do
  use ExUnit.Case
  use Plug.Test

  alias Router
  alias Service.{FrequencyService, PromiseService}

  @options Router.init([])

  # TODO: ajout des tests pour les requetes crud.
  test "Adding a target" do
    {:ok, promises} = PromiseService.get_promises()
    %{"_id" => id} = promises |> Kernel.hd |> Jason.decode!
    {:ok, %{"_id" => id}} = FrequencyService.get_promise_frequency(id)

    conn =
      :post
      |> conn("/target/create/#{id}", %{ "day" => 1 })
      |> Router.call(@options)

    assert conn.state   == :sent
    # Will return 404 if the database is empty.
    assert conn.status  == 200 or conn.status == 404
  end

  test "Adding a target with a non valid frequency" do
    conn =
      :post
      |> conn("/target/create/hello", %{"day" => 1})
      |> Router.call(@options)

    assert conn.state == :sent
    assert conn.status == 404
  end

  test "Updating a target with a non valid id" do
    conn =
      :update
      |> conn("/target/hello", %{})
      |> Router.call(@options)

    assert conn.state == :sent
    assert conn.status == 404
  end

  test "deleting a target with a non valid id" do
    conn =
      :delete
      |> conn("/target/hello", %{})
      |> Router.call(@options)

    assert conn.state == :sent
    assert conn.status == 404
  end
end
defmodule Router.FrequenciesTest do
  use ExUnit.Case
  use Plug.Test

  alias Service.PromiseService

  alias Router

  @options Router.init([])

  test "Adding a frequency" do
    {:ok, promises} = PromiseService.get_promises()
    %{"_id" => id} = promises |> Kernel.hd |> Jason.decode!

    conn =
      :post
      |> conn("/frequency/create/#{id}", %{ "count" => 3, "type" => "weekly" })
      |> Router.call(@options)

    assert conn.state   == :sent
    # Will return 404 if the database is empty.
    assert conn.status  == 200 or conn.status == 404
  end

  test "Trying to add a frequency with non existing promise" do
    conn =
      :post
      |> conn("/frequency/create/abde", "")
      |> Router.call(@options)

    assert conn.state   == :sent
    assert conn.status  == 404
  end

  test "Updating a frequency" do

    {:ok, promises} = PromiseService.get_promises()
    %{"_id" => id} = promises |> Kernel.hd |> Jason.decode!
    conn =
      :put
      |> conn("/frequency/update/#{id}", %{"count" => 3, "type" => "weekly"})
      |> Router.call(@options)

    assert conn.state   == :sent
    # Will return 404 if the database is empty.
    assert conn.status  == 200 or conn.status == 404
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

  test "Deleting a promise" do
    {:ok, promises} = PromiseService.get_promises()
    %{"_id" => id} = promises |> Kernel.hd |> Jason.decode!
    conn =
      :delete
      |> conn("/frequency/delete/#{id}", "")
      |> Router.call(@options)

    assert conn.state   == :sent
    # Will return 404 if the database is empty.
    assert conn.status  == 200 or conn.status == 404
  end

end
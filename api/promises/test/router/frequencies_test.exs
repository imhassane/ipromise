defmodule Endpoint.FrequenciesTest do
  use ExUnit.Case
  use Plug.Test

  alias Service.PromiseService

  alias Endpoint

  @options Endpoint.init([])

  @base     "/frequencies"
  @details  "/frequencies"
  @create   "/frequencies"
  @update   "/frequencies"
  @delete   "/frequencies"

  test "Adding a frequency" do
    with {:ok, promises}  <- PromiseService.get_promises(),
      %{"_id" => id}      <- promises |> Kernel.hd |> Jason.decode!()
    do
      conn =
        :post
        |> conn("#{@create}/#{id}", %{ "count" => 3, "type" => "weekly" })
        |> Endpoint.call(@options)

      assert conn.state   == :sent
      # Will return 404 if the database is empty.
      assert conn.status  == 200 or conn.status == 404
    end
  end

  test "Trying to add a frequency with non existing promise" do
    conn =
      :post
      |> conn("#{@create}/abde", "")
      |> Endpoint.call(@options)

    assert conn.state   == :sent
    assert conn.status  == 404
  end

  test "Updating a frequency" do
    with {:ok, promises}  <- PromiseService.get_promises(),
      %{"_id" => id}      <- promises |> Kernel.hd |> Jason.decode!()
    do
      conn =
        :put
        |> conn("#{@update}/#{id}", %{"count" => 3, "type" => "weekly"})
        |> Endpoint.call(@options)

      assert conn.state   == :sent
      # Will return 404 if the database is empty.
      assert conn.status  == 200 or conn.status == 404
    end
  end

  test "Trying to update a frequency with non valid id" do
    conn =
      :put
      |> conn("#{@update}/abde", "")
      |> Endpoint.call(@options)

    assert conn.state == :sent
    assert conn.status == 400
  end

  test "Trying to delete a non existant frequency" do
    conn =
      :delete
      |> conn("#{@delete}/abde", "")
      |> Endpoint.call(@options)

    assert conn.state == :sent
    assert conn.status == 404
  end

  test "Deleting a promise" do
    with {:ok, promises}    <- PromiseService.get_promises(),
      %{"_id" => id}        <- promises |> Kernel.hd |> Jason.decode!()
    do
      conn =
        :delete
        |> conn("#{@delete}/#{id}", "")
        |> Endpoint.call(@options)

      assert conn.state   == :sent
      # Will return 404 if the database is empty.
      assert conn.status  == 200 or conn.status == 404
    end
  end

end
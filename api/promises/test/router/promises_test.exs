defmodule Endpoint.PromisesTest do
  use ExUnit.Case
  use Plug.Test

  alias Endpoint
  alias Service.PromiseService

  @options Endpoint.init([])

  @base     "/promises"
  @details  "/promises"
  @create   "/promises"
  @update   "/promises"
  @delete   "/promises"

  test "get list of promises" do
    conn =
      :get
      |> conn(@base, "")
      |> Endpoint.call(@options)

      assert conn.state   == :sent
      assert conn.status  == 200
  end

  test "get a non valid promise" do
    conn =
      :get
      |> conn("#{@details}/5ea72b266006b85047597b29", "")
      |> Endpoint.call(@options)

      assert conn.state == :sent
      assert conn.status == 404
  end

  test "get a promise with an invalid argument" do
    conn =
      :get
      |> conn("#{@details}/5ea72b266006", %{})
      |> Endpoint.call(@options)

    assert conn.state == :sent
    assert conn.status == 404
  end

  test "adding an invalid promise" do
    conn =
      :post
      |> conn(@create, %{ "titler" => ""})
      |> Endpoint.call(@options)

    assert conn.state == :sent
    assert conn.status == 400
  end

  test "adding a promise with an invalid title" do

    # The title is invalid if its length is lower than five.
    conn =
      :post
      |> conn(@create, %{ "title" => "cry" })
      |> Endpoint.call(@options)

    assert conn.state   == :sent
    assert conn.status  == 400
  end

  test "adding a promise" do

    # The title is invalid if its length is lower than five.
    conn =
      :post
      |> conn(@create, %{ "title" => "going to the gym" })
      |> Endpoint.call(@options)

    assert conn.state   == :sent
    # Will return 404 if the database is empty.
    assert conn.status  == 200 or conn.status == 404
  end

  test "updating an invalid promise" do
    conn =
      :put
      |> conn("#{@update}/hello", "")
      |> Endpoint.call(@options)

    assert conn.state == :sent
    assert conn.status == 404
  end

  test "updating a promise" do

    %{ "_id" => id } = get_promise()
    conn =
      :put
      |> conn("#{@update}/#{id}", %{"title" => "Hitting the gym"})
      |> Endpoint.call(@options)

    assert conn.state == :sent
    # Will return 404 if the database is empty.
    assert conn.status  == 200 or conn.status == 404
  end

  test "deleting an invalid promise" do
    conn =
      :delete
      |> conn("#{@delete}/hello", "")
      |> Endpoint.call(@options)

    assert conn.state == :sent
    assert conn.status == 404
  end

  test "deleting a promise" do
    {:ok, promises} = PromiseService.get_promises()
    %{"_id" => id} = promises |> Kernel.hd |> Jason.decode!

    conn =
      :delete
      |> conn("#{@delete}/#{id}", %{})
      |> Endpoint.call(@options)

    assert conn.state == :sent
    # Will return 404 if the database is empty.
    assert conn.status  == 200 or conn.status == 404
  end

  test "returns 404" do
    conn =
    :get
    |> conn("/missing", "")
    |> Endpoint.call(@options)

    assert conn.state   == :sent
    assert conn.status  == 404
  end

  defp get_promise() do
    {:ok, promises} = PromiseService.get_promises()
    promises |> Kernel.hd |> Jason.decode!
  end
end
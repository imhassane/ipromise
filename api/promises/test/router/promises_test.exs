defmodule Router.PromisesTest do
  use ExUnit.Case
  use Plug.Test

  alias Router
  alias Service.PromiseService

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

  test "adding an invalid promise" do
    conn =
      :post
      |> conn("/create", %{ "titler" => ""})
      |> Router.call(@options)

    assert conn.state == :sent
    assert conn.status == 400
  end

  test "adding a promise with an invalid title" do

    # The title is invalid if its length is lower than five.
    conn =
      :post
      |> conn("/create", %{ "title" => "cry" })
      |> Router.call(@options)

    assert conn.state   == :sent
    assert conn.status  == 400
  end

  test "adding a promise" do

    # The title is invalid if its length is lower than five.
    conn =
      :post
      |> conn("/create", %{ "title" => "going to the gym" })
      |> Router.call(@options)

    assert conn.state   == :sent
    assert conn.status  == 200
  end

  test "updating an invalid promise" do
    conn =
      :put
      |> conn("/update/hello", "")
      |> Router.call(@options)

    assert conn.state == :sent
    assert conn.status == 404
  end

  test "updating a promise" do
    # Waiting to create a promise.
    Process.sleep(100)

    %{ "_id" => id } = get_promise()
    conn =
      :put
      |> conn("/update/#{id}", %{"title" => "Hitting the gym"})
      |> Router.call(@options)

    assert conn.state == :sent
    assert conn.status == 200
  end

  test "deleting an invalid promise" do
    conn =
      :delete
      |> conn("/delete/hello", "")
      |> Router.call(@options)

    assert conn.state == :sent
    assert conn.status == 404
  end

  test "deleting a promise" do

    # Waiting to create a promise.
    Process.sleep(100)

    {:ok, promises} = PromiseService.get_promises()
    %{"_id" => id} = promises |> Kernel.hd |> Jason.decode!

    conn =
      :delete
      |> conn("/delete/#{id}", %{})
      |> Router.call(@options)

    assert conn.state == :sent
    assert conn.status == 200
  end

  test "returns 404" do
    conn =
    :get
    |> conn("/missing", "")
    |> Router.call(@options)

    assert conn.state   == :sent
    assert conn.status  == 404
  end

  defp get_promise() do
    {:ok, promises} = PromiseService.get_promises()
    promises |> Kernel.hd |> Jason.decode!
  end
end
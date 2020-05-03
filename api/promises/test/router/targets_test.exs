defmodule Endpoint.TargetsTest do
  use ExUnit.Case
  use Plug.Test

  alias Endpoint
  alias Service.{FrequencyService, PromiseService}

  @options Endpoint.init([])

  @base     "/targets"
  @details  "/targets"
  @create   "/targets"
  @update   "/targets"
  @delete   "/targets"

  test "Getting targets for a frequency" do
    with {:ok, promises}    <- PromiseService.get_promises(),
      %{"_id" => id}        <- promises |> Kernel.hd |> Jason.decode!(),
      {:ok, %{"_id" => id}} <- FrequencyService.get_promise_frequency(id)
    do
      conn =
        :get
        |> conn("#{@base}/#{id}", "")
        |> Endpoint.call(@options)

      assert conn.state == :sent
      assert conn.status == 200
    end
  end

  test "Adding a target" do
    with {:ok, promises}    <- PromiseService.get_promises(),
      %{"_id" => id}        <- promises |> Kernel.hd |> Jason.decode!(),
      {:ok, %{"_id" => id}} <- FrequencyService.get_promise_frequency(id)
    do
      conn =
        :post
        |> conn("#{@create}/#{id}", %{ "day" => 1 })
        |> Endpoint.call(@options)

      assert conn.state   == :sent
      # Will return 404 if the database is empty.
      assert conn.status  == 200 or conn.status == 404
    end
  end

  test "Adding a target with a non valid frequency" do
    conn =
      :post
      |> conn("#{@create}/hello", %{"day" => 1})
      |> Endpoint.call(@options)

    assert conn.state == :sent
    assert conn.status == 404
  end

  test "Updating a target with a non valid id" do
    conn =
      :put
      |> conn("#{@update}/hello", %{"day" => 2, "done" => true})
      |> Endpoint.call(@options)

    assert conn.state == :sent
    assert conn.status == 404
  end

  test "deleting a target with a non valid id" do
    conn =
      :delete
      |> conn("#{@delete}/hello", %{})
      |> Endpoint.call(@options)

    assert conn.state == :sent
    assert conn.status == 404
  end
end
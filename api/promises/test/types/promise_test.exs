defmodule Types.PromiseTest do
  use ExUnit.Case
  doctest Promises

  alias Types.{Promise, Frequency}

  test "creating a new promise" do
    p = Promise.new()
    assert p.title == nil and p.frequency == nil and p.created_at != nil and p.updated_at != nil and p.user == nil
  end

  test "adding a frequency with a frequency as argument" do
    f = Frequency.new()
    {:ok, p} = Promise.new() |> Promise.add_frequency(f)
    assert p.frequency != nil
  end

  test "adding a frequency with a type as argument (daily)" do
    {:ok, p} = Promise.new() |> Promise.add_frequency("daily")
    assert p.frequency != nil
  end

  test "adding a frequency with a type as argument (weekly)" do
    {:ok, p} = Promise.new() |> Promise.add_frequency("weekly")
    assert p.frequency != nil
  end

  test "adding a frequency with non correct values string" do
    {response, _} = Promise.new() |> Promise.add_frequency("monthly")
    assert response == :error
  end

  test "adding a frequency with non correct values number" do
    {response, _} = Promise.new() |> Promise.add_frequency(10)
    assert response == :error
  end

  test "adding a frequency with non correct values atoms" do
    {response, _} = Promise.new() |> Promise.add_frequency(:daily)
    assert response == :error
  end

end
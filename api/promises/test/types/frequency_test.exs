defmodule Types.FrequencyTest do
  use ExUnit.Case
  alias Types.{Frequency, Target}

  test "create a new frequency" do
    f = Frequency.new()
    assert f.type == :daily and f.repeat == 0 and f.targets == nil and f.created_at != nil and f.updated_at != nil
  end

  test "adding a target to the frequency" do
    t = Target.new()
    {:ok, f} = Frequency.new() |> Frequency.add_target(t)
    assert f.targets != nil
  end

  test "updating the daily frequency" do
    {:ok, f} = Frequency.new() |> Frequency.update_type("daily")
    assert f.type == :daily
  end

  test "updating the weekly frequency" do
    {:ok, f} = Frequency.new() |> Frequency.update_type("weekly")
    assert f.type == :weekly
  end

  test "updating the frequency type for a random value" do
    {response, _} = Frequency.new() |> Frequency.update_type("monthly")
    assert response == :error
  end

  end
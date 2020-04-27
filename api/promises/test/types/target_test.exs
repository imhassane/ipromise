defmodule Types.TargetTest do
  use ExUnit.Case
  doctest Promises

  alias Types.Target

  test "Create new target" do
    %Target{ day: day, done: done} = Target.new()
    assert day == Date.day_of_week(Date.utc_today) and done == false
  end

  test "Updating a target's day" do
    {:ok, %Target{ day: day}} = Target.new() |> Target.update_target(5)
    assert day == 5
  end

  test "Updating a target's done" do
    {:ok, %Target{ done: done}} = Target.new() |> Target.update_target(true)
    assert done == true
  end

  test "Updating a target's day and done" do
    {:ok, %Target{ day: day, done: done }} = Target.new() |> Target.update_target(5, true)
    assert day == 5 and done == true
  end

  test "Setting the wrong values to a target" do
    {response, _} = Target.new() |> Target.update_target("5")
    assert response == :error
  end

  test "Setting the wrong values to a target update_target/2" do
    {response, _} = Target.new() |> Target.update_target(5, "val")
    assert response == :error
  end

end

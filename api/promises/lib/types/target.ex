defmodule Types.Target do

  @derive Jason.Encoder
  defstruct _id: nil, day: nil, done: false

  def new(), do: %Types.Target{ day: Date.day_of_week(Date.utc_today), done: false }

  def update_target(%Types.Target{} = target, day) when is_integer(day) and day <= 7 do
    {:ok, %Types.Target{ target | day: day }}
  end

  def update_target(%Types.Target{} = target, done) when is_boolean(done) do
    {:ok, %Types.Target{ target | done: done }}
  end

  def update_target(_, _), do: {:error, "You should enter valid parameters"}

  def update_target(%Types.Target{} = target, day, done) when is_integer(day) and is_boolean(done) do
    with {:ok, target} <- target |> update_target(day),
         {:ok, target} <- target |> update_target(done) do
      {:ok, target}
    end
  end

  def update_target(_, _, _), do: {:error, "You should enter valid parameters"}

end

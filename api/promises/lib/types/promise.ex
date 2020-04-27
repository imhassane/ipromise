defmodule Types.Promise do

  alias Types.Frequency

  @derive Jason.Encoder
  defstruct _id: nil, title: nil, frequency: nil, created_at: nil, updated_at: nil, user: nil, claps: 0, comments: [], is_public: false

  def new(), do: %Types.Promise{created_at: NaiveDateTime.utc_now, updated_at: NaiveDateTime.utc_now}

  def add_frequency(%Types.Promise{} = promise, %Frequency{} = frequency) do
    {:ok, %Types.Promise{ promise | frequency: frequency}}
  end

  def add_frequency(%Types.Promise{} = promise, "daily" = type) do
    {:ok, f} = Frequency.new() |> Frequency.update_type(type)
    promise |> add_frequency(f)
  end

  def add_frequency(%Types.Promise{} = promise, "weekly" = type) do
    {:ok, f} = Frequency.new() |> Frequency.update_type(type)
    promise |> add_frequency(f)
  end

  def add_frequency(_, _), do: {:error, "Cannot add the frequency: The given frequency is not correct"}
end
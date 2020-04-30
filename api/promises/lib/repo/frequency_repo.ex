defmodule Repo.FrequencyRepo do

  @collection "frequencies"

  # Get a promise's frequency.
  def get_frequency(promise_id) do
    :database |> Mongo.find_one(@collection, %{ "promise" => id })
  end

  # Adding a new Frequency.
  def add_frequency(frequency) do
    :database |> Mongo.insert_one!(@collection, frequency)
  end

  # Updating the frequency.
  def update_frequency(%{ "_id" => id } = frequency) do
    :database |> Mongo.update_one(@collection, %{ "_id" => id }, %{ "$set": frequency })
  end

  # deleting the frequency.
  def delete_frequency(id) do
    :database |> Mongo.delete_one(@collection, %{ "_id" => id })
  end
end
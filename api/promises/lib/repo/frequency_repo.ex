defmodule Repo.FrequencyRepo do

  @collection "frequencies"

  # Get a promise's frequency.
  def get_promise_frequency(id) do
    :database |> Mongo.find_one(@collection, %{ "promise" => id })
  end

  # Get a frequency.
  def get_frequency(id) do
    :database |> Mongo.find_one(@collection, %{ "_id" => id })
  end

  # Adding a new Frequency.
  def add_frequency(frequency) do
    :database |> Mongo.insert_one!(@collection, frequency)
  end

  # Updating the frequency.
  def update_frequency(%{ "_id" => id } = frequency) do
    :database |> Mongo.update_one(@collection, %{ "_id" => id }, %{ "$set": frequency })
  end

  def update_promise_frequency(%{"promise" => id} = frequency) do
    :database |> Mongo.update_one(@collection, %{ "promise" => id }, %{"$set": frequency}, [new: true])
  end

  # Updating a frequency if it exists given the promise id.
  def find_and_update_promise_frequency(%{"promise" => id} = frequency) do
    :database |> Mongo.find_one_and_update(@collection, %{ "promise" => id }, %{ "$set": frequency }, [new: true])
  end

  # deleting the frequency.
  def delete_frequency(id) do
    :database |> Mongo.delete_one(@collection, %{ "_id" => id })
  end

  def delete_promise_frequency(id) do
    :database |> Mongo.delete_one(@collection, %{ "promise" => id })
  end
end
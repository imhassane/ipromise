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
  def add_frequency(%{"promise" => promise} = frequency) do
    with {:ok, inserted} <- Mongo.insert_one(:database, @collection, frequency),
         {:ok, _}        <- Mongo.update_one(:database, "promises", %{"_id" => promise}, %{"$set" => %{"frequency" => inserted.inserted_id}})
    do
      frequency = Mongo.find_one(:database, @collection, %{"_id" => inserted.inserted_id})
      {:ok, frequency}
    end
  end

  # Updating the frequency.
  def update_frequency(%{ "_id" => id } = frequency) do
    with {:ok, _}      <- Mongo.update_one(:database, @collection, %{"_id" => id}, %{"$set": frequency})
    do
      result = Mongo.find_one(:database, @collection, %{"_id" => id})
      {:ok, result}
    end
  end

  def update_promise_frequency(%{"promise" => id} = frequency) do
     with {:ok, _} <- Mongo.update_one(:database, @collection, %{"promise" => id}, %{"$set": frequency})
     do
        result = Mongo.find_one(:database, @collection, %{"promise" => id})
        {:ok, result}
     end
  end

  # Updating a frequency if it exists given the promise id.
  def find_and_update_promise_frequency(%{"promise" => id} = frequency), do: update_promise_frequency(frequency)

  # deleting the frequency.
  def delete_frequency(id) do
    with freq           <- Mongo.find_one(:database, @collection, %{"_id" => id}),
         {:ok, deleted} <- Mongo.delete_one(:database, @collection, %{ "_id" => id }),
         {:ok, _}       <- Mongo.update_one(:database, "promises", %{"frequency" => id}, %{"$set": %{"frequency" => nil}}),
         {:ok, _}       <- Mongo.delete_many(:database, "targets", %{"frequency" => id})
    do
      {:ok, freq}
    end
  end

  def delete_promise_frequency(id) do
    with freq           <- Mongo.find_one(:database, @collection, %{"promise" => id}),
         {:ok, deleted} <- Mongo.delete_one(:database, @collection, %{ "promise" => id }),
         {:ok, _}       <- Mongo.update_one(:database, "promises", %{"frequency" => id}, %{"$set": %{"frequency" => nil}}),
         {:ok, _}       <- Mongo.delete_many(:database, "targets", %{"frequency" => id})
    do
      {:ok, freq}
    end
  end
end
defmodule Repo.PromiseRepo do

  alias Types.Promise

  @collection "promises"

  # Getting user's promise
  def get_promises() do
    :database
      |> Mongo.find(@collection, %{})
      |> Enum.to_list()
  end

  # Getting a promise and displaying its details.
  def get_promise(id) do
    :database
    |> Mongo.find_one(@collection, %{ "_id" => id })
  end

  # Adding a promise
  def add_promise(%Promise{} = promise) do
    data = Jason.encode! promise
    result = :database |> Mongo.insert_one(@collection, Jason.decode! data)
    result
  end

  # Updating a promise
  def update_promise(%Promise{ id: id } = promise) do
    data = Jason.encode! promise
    :database |> Mongo.update_one(@collection, %{"_id" => id}, %{"$set": Jason.decode! data})
  end

  # Deleting a promise
  def delete_promise(id) do
    :database |> Mongo.delete_one(@collection, %{ "_id" => id })
  end
end
defmodule Repo.PromiseRepo do

  alias Types.Promise

  @collection "promises"

  # TODO: Getting user's promise
  def get_promises() do
    data =
      :database
      |> Mongo.find(@collection, %{})
      |> Enum.to_list()

    data
  end

  # TODO: Getting a promise and displaying its details.

  def add_promise(%Promise{} = promise) do
    data = Jason.encode! promise
    result = :database |> Mongo.insert_one(@collection, Jason.decode! data)
    result
  end

  def update_promise(%Promise{ id: id } = promise) do
    data = Jason.encode! promise
    result = :database |> Mongo.update_one(@collection, %{"_id": id}, %{"$set": data})
    {:ok, result}
  end

  def delete_promise(%Promise{ id: id } = promise) do
    result = :database |> Mongo.delete_one(@collection, %{ "_id": id })
  end
end
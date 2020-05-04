defmodule Repo.PromiseRepo do

  alias Types.Promise

  @collection "promises"

  # Getting user's promise
  def get_promises() do
    :database
      |> Mongo.find(@collection, %{})
  end

  # Getting a promise and displaying its details.
  def get_promise(id) do
    :database
    |> Mongo.find_one(@collection, %{ "_id" => id })
  end

  # Adding a promise
  def add_promise(%Promise{} = promise) do
    data = Jason.encode! promise
    {:ok, result } = :database |> Mongo.insert_one(@collection, Jason.decode! data)
    result = Mongo.find_one(:database, @collection, %{"_id" => result.inserted_id})
    {:ok, result}
  end

  # Updating a promise
  def update_promise(%{ "_id" => id } = promise) do
    with {:ok, _} <- Mongo.update_one(:database, @collection, %{"_id" => id}, %{"$set": promise }) do
      result = Mongo.find_one(:database, @collection, %{"_id" => id})
      {:ok, result}
    end
  end

  # Deleting a promise
  def delete_promise(id) do
    with  promise             <- Mongo.find_one(:database,    @collection,    %{"_id" => id}),
          freq                <- Mongo.find_one(:database,    "frequencies",  %{"promise"=>id}),
          {:ok, _}            <- Mongo.delete_one(:database,   @collection,    %{"_id" => id}),
          {:ok, _}            <- Mongo.delete_one(:database,  "frequencies",  %{"promise"=>id}),
          {:ok, _}            <- Mongo.delete_many(:database, "targets",      %{"frequency" => freq["_id"]})
    do
      {:ok, promise}
    end
  end
end
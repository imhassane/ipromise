defmodule Repo.TargetRepo do

  @collection "targets"

   # Getting targets for a frequency.
  def get_frequency_targets(freq_id) do
    :database |> Mongo.find(@collection, %{"frequency" => freq_id})
  end

  def get_target(id) do
    :database |> Mongo.find_one(@collection, %{ "_id" => id })
  end

   # Adding a new target.
  def add_target(target) do
    with {:ok, result } <- Mongo.insert_one(:database, @collection, target) do
      result = Mongo.find_one(:database, @collection, %{"_id" => result.inserted_id})
      {:ok, result}
    end
  end

   # Updating the target.
   def update_target(%{"_id" => id} = target) do
      with {:ok, _} <- Mongo.update_one(:database, @collection, %{ "_id" => id}, %{"$set": target}) do
        result = Mongo.find_one(:database, @collection, %{"_id" => id})
        {:ok, result}
      end
  end

   # Deleting the target.
   def delete_target(id) do
     with target <- Mongo.find_one(:database, @collection, %{"_id" => id}),
          {:ok, _} <- Mongo.delete_one(:database, @collection, %{"_id" => id}) do
       {:ok, target}
     end
  end
end
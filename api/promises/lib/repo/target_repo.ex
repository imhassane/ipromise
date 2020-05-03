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
    :database |> Mongo.insert_one(@collection, target)
  end

   # Updating the target.
   def update_target(%{"_id" => id} = target) do
     :database |> Mongo.update_one(@collection, %{ "_id" => id}, %{"$set": target})
  end

   # Deleting the target.
   def delete_target(id) do
     :database |> Mongo.delete_one(@collection, %{"_id" => id})
  end
end
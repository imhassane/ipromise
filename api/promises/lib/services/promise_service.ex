defmodule Service.PromiseService do

  alias Types.{Promise}
  alias Repo.{PromiseRepo}

  # Getting user's promise
  def get_promises() do
    promises = PromiseRepo.get_promises()

    promises = promises
              |> Enum.map(fn (%{"_id" => id} = p) ->
                            id = BSON.ObjectId.encode!(id)
                            %{ p | "_id" => id } |> Jason.encode!()
                          end)
    {:ok, promises}
  end

  # Getting a promise and displaying its details.
  def get_promise(id) when is_binary(id) do
    id = BSON.ObjectId.decode!(id)
    promise = PromiseRepo.get_promise(id)
    if promise do
      promise = %{ promise | "_id" => BSON.ObjectId.encode!(id) } |> Jason.encode!()
      {:ok, promise}
    else
      {:not_found, "The promise with the given ID does not exist"}
    end
  end

  def get_promise(_), do: {:not_found, "The promise with the given ID does not exist"}

  # Adding a new promise.
  def add_promise(%Promise{ title: title } = promise) do

    if title == nil or String.length(title) < 5 do
      {:malformed_data, "The title should be at least 5 characters"}
    end

    promise = promise |> PromiseRepo.add_promise()

    case promise do
      {:ok, _} -> {:ok, "The promise has been added successfully"}
             _ -> {:internal_server, "Unable to add the promise, try later"}
    end

  end

  def add_promise(_), do: {:malformed_data, "Unable to add the promise, the given data is not correct"}

  # TODO: Updating a promise.

  # Deleting a promise.
  def delete_promise(id) when is_binary(id) do
    with {:ok, promise} <- get_promise(id),
               _promise <- Jason.decode!(promise) do
      # TODO: This is not working as expected
      PromiseRepo.delete_promise(id)
      {:ok, "The promise has been deleted successfully"}
    end
  end

  def delete_promise(_), do: {:not_found, "The promise with the given ID does not exist"}
end
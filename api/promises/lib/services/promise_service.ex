defmodule Service.PromiseService do

  alias Types.{Promise}
  alias Repo.{PromiseRepo}

  # TODO: Getting user's promise
  def get_promises() do
    promises = PromiseRepo.get_promises()

    promises = promises
              |> Enum.each(fn (%{"_id" => id} = p) ->
                            %BSON.ObjectId{value: value} = id
                            %{ p | "_id" => value } |> BSON.decode()
                          end)

    {:ok, promises}
  end

  # TODO: Getting a promise and displaying its details.

  # TODO: Adding a new promise.
  def add_promise(%Promise{ title: title } = promise) do

    if title == nil or String.length(title) < 5 do
      {:malformed_data, "The title should be at least 5 characters"}
    end

    promise = promise |> PromiseRepo.add_promise()

    case promise do
      {:ok, _} -> {:ok, "The promise has been added successfully"}
             _ -> {:internal_server_, "Unable to add the promise, try later"}
    end

  end

  # TODO: Updating a promise.

  # TODO: Deleting a promise.
end
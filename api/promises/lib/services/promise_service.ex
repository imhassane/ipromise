defmodule Service.PromiseService do

  alias Types.{Promise}
  alias Repo.{PromiseRepo}

  # Getting user's promise
  def get_promises() do
    promises = PromiseRepo.get_promises()

    promises = promises
              |> Enum.map(fn (p) -> p |> convert_promise_to_json |> Jason.encode! end)
    {:ok, promises}
  end

  # Getting a promise and displaying its details.
  def get_promise(id) when is_binary(id) do
    try do
      id = BSON.ObjectId.decode!(id)
      promise = PromiseRepo.get_promise(id)
      if promise do
        promise =
          promise|> convert_promise_to_json
        {:ok, promise}
      else
        {:not_found, "The promise with the given ID does not exist"}
      end
    rescue
      _ in FunctionClauseError -> {:not_found, "The promise with the given ID does not exist"}
    end
  end

  def get_promise(_), do: {:not_found, "The promise with the given ID does not exist"}

  # Adding a new promise.
  def add_promise(%{ "title" => title }) do

    if title == nil or String.length(title) < 5 do
      {:malformed_data, "The title should be at least 5 characters"}
    else
      # I'm using the Promise.new because of its date initialisation.
      promise = Promise.new(title) |> PromiseRepo.add_promise()

      case promise do
        {:ok, _} -> {:ok, "The promise has been added successfully"}
               _ -> {:internal_server, "Unable to add the promise, try later"}
      end
    end
  end

  def add_promise(_), do: {:malformed_data, "Unable to add the promise, the title is not correct"}

  # TODO: Updating a promise.
  def update_promise(id, %{"title" => _title} = promise) do
    try do
      id = BSON.ObjectId.decode!(id)

      promise =
        case Map.has_key?( promise, "frequency") do
          true -> %{ promise | "frequency" => BSON.ObjectId.decode!(promise["frequency"]) }
          false -> promise
        end

      result =
        promise
        |> Map.put("_id", id)
        |> PromiseRepo.update_promise()

      result =
        case result do
          {:ok, nil} -> :not_found
          {:ok, _promise} -> :ok
          {_, _} -> :error
        end

      unless result == :ok do
          {:not_found, "The promise with the given ID does not exist"}
      else
        id = BSON.ObjectId.encode!(id)
        promise =
          promise
            |> Map.put("_id", id)
            |> convert_promise_to_json
        {:ok, promise}
      end

    rescue
      _ in KeyError -> {:not_found, "The promise with the given ID does not exist"}
      # TODO: capture other exceptions
    end
  end
  def update_promise(_, _), do: {:not_found, "Here we are"}

  # Deleting a promise.
  def delete_promise(id) when is_binary(id) do
    try do
      with {:ok, promise} <- get_promise(id),
                 _promise <- Jason.decode!(promise) do
        # TODO: This is not working as expected
        PromiseRepo.delete_promise(id)
        {:ok, "The promise has been deleted successfully"}
      end
    rescue
      _ in FunctionClauseError -> {:not_found, "The promise with the given ID does not exist"}
    end
  end

  def delete_promise(_), do: {:not_found, "The promise with the given ID does not exist"}

  defp convert_promise_to_json(%{
    "frequency" => frequency,
    "_id" => id } = promise
  ) when not is_nil(frequency) and not is_binary(id) do
    %{ promise |
      "_id"       => BSON.ObjectId.encode!(id),
      "frequency" => BSON.ObjectId.encode!(frequency)
    }
  end
  defp convert_promise_to_json(%{ "_id" => id } = promise) when not is_binary(id) do
    %{ promise |
      "_id" => BSON.ObjectId.encode!(id)
    }
  end
  defp convert_promise_to_json(promise), do: promise

end
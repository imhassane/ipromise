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
        {:ok, promise} -> {:ok, convert_promise_to_json(promise)}
               _ -> {:internal_server, "Unable to add the promise, try later"}
      end
    end
  end

  def add_promise(_), do: {:malformed_data, "Unable to add the promise, the title is not correct"}

  # Updating a promise.
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
          {:ok, nil} -> {:not_found, "The promise does not exist"}
          {:ok, promise} -> {:ok, convert_promise_to_json(promise)}
          {_, _} -> {:error, "Unable to update the promise"}
        end

    rescue
      _ in FunctionClauseError -> {:not_found, "The promise with the given ID does not exist"}
    end
  end
  def update_promise(_, _), do: {:not_found, "Here we are"}

  # Deleting a promise.
  def delete_promise(id) when is_binary(id) do
    try do
      id = BSON.ObjectId.decode!(id)
      result = PromiseRepo.delete_promise(id)
      case result do
        {:ok, nil} -> {:not_found, "The promise with the given ID does not exist"}
        {:ok, promise} -> {:ok, convert_promise_to_json(promise)}
        {:error, _} -> {:error, "Unable to delete the promise"}
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
  defp convert_promise_to_json(%{ "_id" => id, "frequency" => frequency } = promise)
       when not is_binary(id) and is_nil(frequency)
  do
    %{ promise |
      "_id" => BSON.ObjectId.encode!(id)
    }
  end
  defp convert_promise_to_json(%{ "_id" => id, "frequency" => frequency } = promise)
       when not is_nil(frequency) and is_binary(id)
  do
    %{
      promise |
      "frequency" => BSON.ObjectId.encode!(frequency)
    }
  end
  defp convert_promise_to_json(promise), do: promise

end
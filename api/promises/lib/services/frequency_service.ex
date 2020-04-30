defmodule Service.FrequencyService do

  alias Repo.FrequencyRepo

  # TODO: Get the frequency of a promise.
  def get_promise_frequency() do

  end

  # Adding a new Frequency.
  def add_frequency(promise_id, %{ "type" => type, "count" => count } = frequency) do

    unless String.length(type) > 5 and count > 0, do: {:malformed_data, "The type should have at least 5 characters and the frequency 1"}

    try do
      promise_id = BSON.ObjectId.decode!(promise_id)
      frequency = Map.put frequency, "promise", promise_id

      # If a frequency with the ID exists.
      result =
        case FrequencyRepo.find_and_update_promise_frequency(frequency) do
          {:ok, nil} -> :should_create
          {:ok, _ } -> :updated
          {_, _}    -> :should_create
        end

      # We create a new frequency.
      if result == :should_create, do: FrequencyRepo.add_frequency(frequency)

      frequency = FrequencyRepo.get_promise_frequency(promise_id)
      {:ok, encode_frequency(frequency)}
    rescue
      _ in FunctionClauseError -> {:not_found, "The promise with the given ID doesn't exist"}
      _ -> {:server_error, nil }
    end
  end

  def add_frequency(_, _), do: {:not_found, "The frequency should have a title and a repetition number"}

  # TODO: Updating the frequency.
  def update_frequency(promise_id, %{"type" => _title, "count" => _count} = frequency) do

    unless String.length(type) > 5 and count > 0, do: {:malformed_data, "The type should have at least 5 characters and the frequency 1"}

    try do
      id = BSON.ObjectId.decode!(promise_id)
      frequency = Map.put frequency, "promise", id

      result =
        case FrequencyRepo.update_promise_frequency(frequency) do
          {:ok, _ } -> :updated
                  _ -> :error
        end

      unless result == :updated do
        {:error, "Unable to update the frequency"}
      end

      frequency = FrequencyRepo.get_promise_frequency(id)
      {:ok, encode_frequency(frequency)}
    rescue
      _ in FunctionClauseError -> {:not_found, "The promise with the given ID doesn't exist"}
      _ -> {:server_error, nil }
    end
  end

  def update_frequency(_, _), do: {:malformed_data, "Unable to update the promise: please enter the type and the number of repetitions"}

  # TODO: deleting the frequency.
  def delete_frequency(promise_id) do
    try do
      id = BSON.ObjectId.decode!(promise_id)
      frequency = FrequencyRepo.get_promise_frequency(id)

      FrequencyRepo.delete_promise_frequency(id)

      {:ok, encode_frequency(frequency)}
    rescue
      _ in FunctionClauseError -> {:not_found, "The promise with the given ID doesn't exist"}
      _ -> {:server_error, nil }
    end
  end

  defp encode_frequency(%{ "_id" => id, "promise" => promise } = frequency) do
    %{ frequency | "_id" => BSON.ObjectId.encode!(id), "promise" => BSON.ObjectId.encode!(promise) }
  end
  defp encode_frequency(frequency), do: frequency

end
defmodule Service.FrequencyService do

  alias Repo.FrequencyRepo

  # Get the frequency of a promise.
  def get_promise_frequency(id) do
    try do
      id = BSON.ObjectId.decode!(id)
      frequency = FrequencyRepo.get_promise_frequency(id)
      if frequency do
        {:ok, encode_frequency(frequency)}
      else
        {:not_found, "The frequency for the given promise ID does not exist"}
      end

    rescue
      _ in FunctionClauseError -> {:not_found, "The frequency for the given promise ID does not exist"}
    end
  end

  # Adding a new Frequency.
  def add_frequency(promise_id, %{ "type" => _type, "count" => _count } = frequency) do

    unless is_valid?(frequency) do
      {:malformed_data, "Unable to update: please enter the correct data"}
    else
      try do
        promise_id = BSON.ObjectId.decode!(promise_id)
        frequency = Map.put frequency, "promise", promise_id

        case FrequencyRepo.add_frequency(frequency) do
          {:ok, frequency}  -> {:ok, encode_frequency(frequency)}
          {:error, _}       -> {:error, "Unable to add the frequency"}
        end
      rescue
        _ in FunctionClauseError -> {:not_found, "The promise with the given ID doesn't exist"}
        _ -> {:server_error, nil }
      end
    end

  end

  def add_frequency(_, _), do: {:not_found, "The frequency should have a type and a repetition number"}

  # Updating the frequency.
  def update_frequency(promise_id, %{"type" => _type, "count" => _count} = frequency) do

    unless is_valid?(frequency) do
      {:malformed_data, "Unable to update: please enter correct data"}
    else
      try do
        id = BSON.ObjectId.decode!(promise_id)
        frequency = Map.put frequency, "promise", id

        result = FrequencyRepo.update_promise_frequency(frequency)
        case result do
          {:ok, nil}      -> {:not_found, "The frequency does not exist"}
          {:ok, frequency}  -> {:ok, encode_frequency(frequency)}
          {:error, _}     -> {:error, "Unable to updated the frequency"}
        end
      rescue
        _ in FunctionClauseError -> {:not_found, "The promise with the given ID doesn't exist"}
      end
    end
  end

  def update_frequency(_, _), do: {:malformed_data, "Unable to update the promise: please enter the type and the number of repetitions"}

  # deleting the frequency.
  def delete_frequency(promise_id) do
    try do
      id = BSON.ObjectId.decode!(promise_id)

      result = FrequencyRepo.delete_promise_frequency(id)
      IO.inspect result
      case result do
        {:ok, nil}        -> {:not_found, "Unable to delete: The frequency does not exist"}
        {:ok, frequency}  -> {:ok, encode_frequency(frequency)}
        {:error, _}       -> {:error, "Unable to delete the frequency"}
      end
    rescue
      _ in FunctionClauseError -> {:not_found, "The promise with the given ID doesn't exist"}
    end
  end

  defp encode_frequency(%{ "_id" => id, "promise" => promise } = frequency) do
    %{ frequency | "_id" => BSON.ObjectId.encode!(id), "promise" => BSON.ObjectId.encode!(promise) }
  end
  defp encode_frequency(frequency), do: frequency

  defp is_valid?(%{ "type" => type, "count" => count }) do
    # A frequency is valid only if the type is either weekly or daily
    # and the repetition greater than 0.
    type = type |> String.downcase |> String.to_atom

    result = type == :weekly
    result = result or type == :daily
    result = result and count > 0
    result
  end
  defp is_valid?(_), do: false

end
defmodule Service.TargetService do

  alias Repo.{TargetRepo}

  # Getting the target for a frequency.
  def get_frequency_targets(frequency_id) do
    try do
      id = BSON.ObjectId.decode!(frequency_id)
      targets = TargetRepo.get_frequency_targets(id)
      targets =
        targets
        |> Enum.map(fn (t) -> convert_target_to_json(t) end)

      if targets do
        {:ok, targets}
        else
        {:ok, []}
      end
    rescue
      _ in FunctionClauseError -> {:not_found, "The frequency with the given ID does not exist"}
    end
  end

  # Getting a target
  def get_target(id) do
    try do
      id = BSON.ObjectId.decode!(id)
      target = TargetRepo.get_target(id)
      if target do
        target = convert_target_to_json(target)
        {:ok, target}
      else
        {:not_found, "The target with the given ID does not exist"}
      end
    rescue
      _ in FunctionClauseError -> {:not_found, "The frequency with the given ID does not exist"}
    end
  end

  # Adding a new target.
  def add_target(frequency, target) do
    unless is_valid?(target) do
      {:malformed_data, "Unable to add the target: the day should be between 1 and 7"}
    else
      try do
        frequency = BSON.ObjectId.decode!(frequency)
        target =
          target
          |> Map.put("frequency", frequency)
          |> Map.put("done", false)


        case TargetRepo.add_target(target) do
          {:ok, target} -> {:ok, convert_target_to_json(target)}
          {_, _} -> {:error, "Unable to add the target"}
        end
      rescue
          _ in FunctionClauseError -> {:not_found, "The frequency with the given ID does not exist"}
      end
    end
  end

  # Updating the target.
  def update_target(id, target) do
    unless is_valid?(target) do
      {:malformed_data, "Unable to update the target: the day should be between 1 and 7"}
    else
      try do
        id = BSON.ObjectId.decode!(id)
        target = Map.put target, "_id", id

        result = TargetRepo.update_target(target)
        case result do
          {:ok, nil} -> {:not_found, "The target does not exist"}
          {:ok, target} -> {:ok, convert_target_to_json(target)}
          {_, _} -> {:error, "Unable to update the target"}
        end
      rescue
        _ in FunctionClauseError -> {:not_found, "The target with the given ID does not exist"}
      end
    end
  end

  # Deleting the target.
  def delete_target(id) do
    try do
      id = BSON.ObjectId.decode!(id)
      result = TargetRepo.delete_target(id)

      case result do
        {:ok, nil} -> {:not_found, "The target does not exist"}
        {:ok, target} -> {:ok, convert_target_to_json(target)}
        {_, _} -> {:error, "Unable to delete the target"}
      end
    rescue
      _ in FunctionClauseError -> {:not_found, "The target with the given ID does not exist"}
                            _  -> {:error, "An error occurred internally"}
    end
  end

  defp is_valid?(%{"day" => day, "done" => done}) when is_boolean(done) do
    is_valid?(%{"day" => day})
  end
  defp is_valid?(%{"day" => day} = target) when is_binary(day) do
    %{ target | "day" => String.to_integer(day) } |> is_valid?
  end
  defp is_valid?(%{"day" => day}) when is_integer(day) do
    day > 0 and day < 8
  end
  defp is_valid?(_), do: false

  defp convert_target_to_json(%{ "_id" => id, "frequency" => freq} = target) do
    %{ target |
      "_id" => BSON.ObjectId.encode!(id),
      "frequency" => BSON.ObjectId.encode!(freq)
    }
  end
  defp convert_target_to_json(%{ "_id" => id } = target) do
    %{ target |
      "_id" => BSON.ObjectId.encode!(id)
    }
  end
  defp convert_target_to_json(%{"frequency" => freq} = target) do
    %{ target |
      "frequency" => BSON.ObjectId.encode!(freq)
    }
  end
  defp convert_target_to_json(target), do: target

end
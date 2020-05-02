defmodule Service.TargetService do

  alias Repo.{TargetRepo}

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


        TargetRepo.add_target(target)

        target = convert_target_to_json(target)
        {:ok, target}
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
        {:ok, result} = TargetRepo.update_target(target)

        if result.modified_count == 0 do
          {:not_found, "The target with the given ID does not exist"}
        else
          target = convert_target_to_json(target)
          {:ok, target}
        end
      rescue
        _ in FunctionClauseError -> {:not_found, "The target with the given ID does not exist"}
      end
    end
  end

  # TODO: Deleting the target.

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
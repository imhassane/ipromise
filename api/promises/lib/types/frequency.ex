defmodule Types.Frequency do

  @derive Jason.Encoder
  defstruct _id: nil, type: :daily, repeat: 0, targets: nil, created_at: nil, updated_at: nil

  # TODO: Changer le naivedatetime pour le faire correspondre au timezone de l'utilisateur.
  def new(), do: %Types.Frequency{ created_at: NaiveDateTime.utc_now, updated_at: NaiveDateTime.utc_now }

  def add_target(%Types.Frequency{ targets: targets } = frequency, %Types.Target{} = target) do
    {:ok, %Types.Frequency{ frequency | targets: [ target | targets ] }}
  end

  def add_target(_, _), do: {:error, "Cannot add the target, the target is not valid"}

  def update_type(%Types.Frequency{} = frequency, "daily" = type) do
    frequency |> pupdate_type(type)
  end

  def update_type(%Types.Frequency{} = frequency, "weekly" = type) do
    frequency |> pupdate_type(type)
  end

  def update_type(_, _), do: {:error, "Cannot update the frequency, the type must be either daily or weekly"}

  defp pupdate_type(%Types.Frequency{} = frequency, type) when is_binary(type) do
    frequency |> pupdate_type(String.to_atom type)
  end

  defp pupdate_type(%Types.Frequency{} = frequency, type) when is_atom(type) do
    {:ok, %Types.Frequency{ frequency | type: type }}
  end

end
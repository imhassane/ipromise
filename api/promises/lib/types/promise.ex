defmodule Types.Promise do

  alias Types.Frequency

  @derive {Jason.Encoder, except: [:id, :_id]}
  defstruct id: nil, title: nil, frequency: nil, created_at: nil, updated_at: nil, user: nil, claps: 0, comments: [], is_public: false, is_visible: true

  def new(), do: %Types.Promise{created_at: NaiveDateTime.utc_now, updated_at: NaiveDateTime.utc_now}

  def new(title) when is_binary(title) do
    p = new()
    %Types.Promise{ p | title: title }
  end

  def new(_), do: {:error, "Cannot create a promise, the title is not correct"}

  def add_frequency(%Types.Promise{} = promise, %Frequency{} = frequency) do
    {:ok, %Types.Promise{ promise | frequency: frequency}}
  end

  def add_frequency(%Types.Promise{} = promise, "daily" = type) do
    {:ok, f} = Frequency.new() |> Frequency.update_type(type)
    promise |> add_frequency(f)
  end

  def add_frequency(%Types.Promise{} = promise, "weekly" = type) do
    {:ok, f} = Frequency.new() |> Frequency.update_type(type)
    promise |> add_frequency(f)
  end

  def add_frequency(_, _), do: {:error, "Cannot add the frequency: The given frequency is not correct"}

  def valid?(%Types.Promise{ title: title, created_at: created_at, updated_at: updated_at, user: user } = promise) do
    result = title != nil
    result = result and String.length title > 3
    result = result and created_at != nil
    result = result and updated_at != nil
    result = result and user != nil
    result
  end

  def to_promise(%{
    "_id" => object_id,
    "id" => id,
    "title" => title,
    "created_at" => created_at,
    "updated_at" => updated_at,
    "claps" => claps,
    "frequency" => frequency,
    "is_public" => is_public,
    "is_visible" => is_visible,
    "comments" => comments,
    "user" => user
  } = _promise) do
    %Types.Promise{
      id: Bson.ObjectId.decode!(object_id) or id,
      title: title,
      created_at: NaiveDateTime.from_iso8601(created_at),
      updated_at: NaiveDateTime.from_iso8601(updated_at),
      claps: claps,
      is_public: is_public,
      is_visible: is_visible,
      frequency: frequency,
      comments: comments,
      user: user
    }
  end
end
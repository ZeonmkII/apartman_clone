defmodule Apartman.Facility do
  @moduledoc """
  The Facility context.
  """

  import Ecto.Query, warn: false
  alias Apartman.Repo
  alias Bolt.Sips, as: Neo
  alias Apartman.Facility.Building

  @doc """
  Convert result from Neo4j (map) into Absinthe prefered format
  """
  def map_to_absinthe(node) do
    %{
      id: node["uuid"],
      name: node["name"],
      address: node["address"],
      tax_id: node["taxId"],
      phone: node["phone"],
      calc_type_water: node["calcTypeWater"],
      calc_type_electric: node["calcTypeElectric"],
      unit_price_water: node["unitPriceWater"],
      unit_price_electric: node["unitPriceElectric"],
      number: node["number"],
      b_booked: node["bBooked"],
      b_occupied: node["bOccupied"]
    }
  end

  # **********************************************************
  # *                                                        *
  # *                    Building                            *
  # *                                                        *
  # **********************************************************
  @doc """
  Returns the list of buildings.

  ## Examples

      iex> list_buildings()
      [%Building{}, ...]

  """
  def list_buildings do
    conn = Neo.conn()
    query = "MATCH (b:Building) WHERE NOT exists(b.delete) RETURN b AS Building"
    response = Neo.query!(conn, query)

    _buildings =
      Enum.map(response.results, & &1["Building"])
      |> Enum.map(& &1.properties)
      |> Enum.map(&map_to_absinthe/1)
  end

  @doc """
  Gets a single building.

  Raises `Ecto.NoResultsError` if the Building does not exist.

  ## Examples

      iex> get_building!(123)
      %Building{}

      iex> get_building!(456)
      ** (Ecto.NoResultsError)

  """
  def get_building!(id) do
    Repo.Node.get(Building, id)
  end

  @doc """
  Creates a building.

  ## Examples

      iex> create_building(%{field: value})
      {:ok, %Building{}}

      iex> create_building(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_building(attrs \\ %{}) do
    %Building{}
    |> Building.changeset(attrs)
    |> Repo.Node.create()
  end

  @doc """
  Updates a building.

  ## Examples

      iex> update_building(building, %{field: new_value})
      {:ok, %Building{}}

      iex> update_building(building, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_building(%Building{} = building, attrs) do
    building
    |> Building.changeset(attrs)
    |> Repo.Node.set()
  end

  @doc """
  Deletes a building.

  ## Examples

      iex> delete_building(building)
      {:ok, %Building{}}

      iex> delete_building(building)
      {:error, %Ecto.Changeset{}}

  """
  def delete_building(id) do
    Repo.Node.get(Building, id)
    |> Repo.Node.delete()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking building changes.

  ## Examples

      iex> change_building(building)
      %Ecto.Changeset{data: %Building{}}

  """
  def change_building(%Building{} = building, attrs \\ %{}) do
    Building.changeset(building, attrs)
  end

  # **********************************************************
  # *                                                        *
  # *                      Floors                            *
  # *                                                        *
  # **********************************************************

  alias Apartman.Facility.Floor

  @doc """
  Returns the list of floors.

  ## Examples

      iex> list_floors()
      [%Floor{}, ...]

  """
  def list_floors do
    conn = Neo.conn()
    query = "MATCH (f:Floor) WHERE NOT exists(f.delete) RETURN f AS Floor"
    response = Neo.query!(conn, query)

    _floors =
      Enum.map(response.results, & &1["Floor"])
      |> Enum.map(& &1.properties)
      |> Enum.map(&map_to_absinthe/1)
  end

  @doc """
  Gets a single floor.

  Raises `Ecto.NoResultsError` if the Floor does not exist.

  ## Examples

      iex> get_floor!(123)
      %Floor{}

      iex> get_floor!(456)
      ** (Ecto.NoResultsError)

  """
  def get_floor!(id) do
    Repo.Node.get(Floor, id)
  end

  @doc """
  Creates a floor.

  ## Examples

      iex> create_floor(%{field: value})
      {:ok, %Floor{}}

      iex> create_floor(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_floor(attrs \\ %{}) do
    %Floor{}
    |> Floor.changeset(attrs)
    |> Repo.Node.create()
  end

  @doc """
  Updates a floor.

  ## Examples

      iex> update_floor(floor, %{field: new_value})
      {:ok, %Floor{}}

      iex> update_floor(floor, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_floor(%Floor{} = floor, attrs) do
    floor
    |> Floor.changeset(attrs)
    |> Repo.Node.set()
  end

  @doc """
  Deletes a floor.

  ## Examples

      iex> delete_floor(floor)
      {:ok, %Floor{}}

      iex> delete_floor(floor)
      {:error, %Ecto.Changeset{}}

  """
  def delete_floor(id) do
    Repo.Node.get(Floor, id)
    |> Repo.Node.delete()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking floor changes.

  ## Examples

      iex> change_floor(floor)
      %Ecto.Changeset{data: %Floor{}}

  """
  def change_floor(%Floor{} = floor, attrs \\ %{}) do
    Floor.changeset(floor, attrs)
  end

  # **********************************************************
  # *                                                        *
  # *                     Rooms                              *
  # *                                                        *
  # **********************************************************

  alias Apartman.Facility.Room

  @doc """
  Returns the list of rooms.

  ## Examples

      iex> list_rooms()
      [%Room{}, ...]

  """
  def list_rooms do
    conn = Neo.conn()
    query = "MATCH (r:Room) WHERE NOT exists(r.delete) RETURN r AS Room"
    response = Neo.query!(conn, query)

    _rooms =
      Enum.map(response.results, & &1["Room"])
      |> Enum.map(& &1.properties)
      |> Enum.map(&map_to_absinthe/1)
  end

  @doc """
  Gets a single room.

  Raises `Ecto.NoResultsError` if the Room does not exist.

  ## Examples

      iex> get_room!(123)
      %Room{}

      iex> get_room!(456)
      ** (Ecto.NoResultsError)

  """
  def get_room!(id) do
    Repo.Node.get(Room, id)
  end

  def get_room_by_number(number) do
    Repo.Node.get_by(Room, %{number: number})
  end

  # Get a random Room
  def get_one_random_room() do
    conn = Neo.conn()

    query =
      "MATCH (r:Room) WHERE r.bBooked = false AND r.bOccupied = false AND NOT exists(r.delete) RETURN r.number AS Room ORDER BY rand() LIMIT 1"

    response = Neo.query!(conn, query)

    _query =
      Enum.map(response.results, & &1["Room"])
      |> List.first()

    # return only UUID
    # query.properties["uuid"]
  end

  @doc """
  Creates a room.

  ## Examples

      iex> create_room(%{field: value})
      {:ok, %Room{}}

      iex> create_room(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_room(attrs \\ %{}) do
    %Room{}
    |> Room.changeset(attrs)
    |> Repo.Node.create()
  end

  @doc """
  Updates a room.

  ## Examples

      iex> update_room(room, %{field: new_value})
      {:ok, %Room{}}

      iex> update_room(room, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_room(%Room{} = room, attrs) do
    room
    |> Room.changeset(attrs)
    |> Repo.Node.set()
  end

  @doc """
  Deletes a room.

  ## Examples

      iex> delete_room(room)
      {:ok, %Room{}}

      iex> delete_room(room)
      {:error, %Ecto.Changeset{}}

  """
  def delete_room(id) do
    Repo.Node.get(Room, id)
    |> Repo.Node.delete()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking room changes.

  ## Examples

      iex> change_room(room)
      %Ecto.Changeset{data: %Room{}}

  """
  def change_room(%Room{} = room, attrs \\ %{}) do
    Room.changeset(room, attrs)
  end
end

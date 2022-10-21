defmodule Apartman.Booking do
  @moduledoc """
  The Booking context.
  """

  import Ecto.Query, warn: false
  alias Apartman.Repo
  alias Bolt.Sips, as: Neo
  alias Apartman.Booking.DailyBooking

  @doc """
  Convert result from Neo4j (map) into Absinthe prefered format
  """
  def map_to_absinthe(node) do
    %{
      id: node["uuid"],
      booking_id: node["bookingId"],
      contract_id: node["contractId"],
      date_signed: node["dateSigned"],
      check_in: node["checkIn"],
      check_out: node["checkOut"],
      time_in: node["timeIn"],
      time_out: node["timeOut"],
      duration_month: node["durationMonth"],
      duration_day: node["durationDay"],
      remarks: node["remarks"],
      from: node["from"],
      to: node["to"],
      room_number: node["roomNumber"],
      rent_fees: node["rentFees"],
      service_fees: node["serviceFees"],
      deposit: node["deposit"],
      advance_payment: node["advancePayment"],
      keycard_fees: node["keycardFees"],
      keycard_number: node["keycardNumber"],
      meter_water: node["meterWater"],
      meter_electric: node["meterElectric"],
      other_labels: node["otherLabels"],
      other_fees: node["otherFees"]
    }
  end

  # **********************************************************
  # *                                                        *
  # *                  Daily Booking                         *
  # *                                                        *
  # **********************************************************

  @doc """
  Returns the list of dailybookings.

  ## Examples

      iex> list_dailybookings()
      [%DailyBooking{}, ...]

  """
  def list_dailybookings do
    conn = Neo.conn()
    query = "MATCH (b:DailyBooking) WHERE NOT exists(b.delete) RETURN b AS DailyBooking"
    response = Neo.query!(conn, query)

    _bookings =
      Enum.map(response.results, & &1["DailyBooking"])
      |> Enum.map(& &1.properties)
      |> Enum.map(&map_to_absinthe/1)
  end

  @doc """
  Gets a single daily_booking.

  Raises `Ecto.NoResultsError` if the Daily booking does not exist.

  ## Examples

      iex> get_daily_booking!(123)
      %DailyBooking{}

      iex> get_daily_booking!(456)
      ** (Ecto.NoResultsError)

  """
  def get_daily_booking!(id) do
    Repo.Node.get(DailyBooking, id)
  end

  @doc """
  Creates a daily_booking.

  ## Examples

      iex> create_daily_booking(%{field: value})
      {:ok, %DailyBooking{}}

      iex> create_daily_booking(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_daily_booking(attrs \\ %{}) do
    %DailyBooking{}
    |> DailyBooking.changeset(attrs)
    |> Repo.Node.create()
  end

  @doc """
  Updates a daily_booking.

  ## Examples

      iex> update_daily_booking(daily_booking, %{field: new_value})
      {:ok, %DailyBooking{}}

      iex> update_daily_booking(daily_booking, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_daily_booking(%DailyBooking{} = daily_booking, attrs) do
    daily_booking
    |> DailyBooking.changeset(attrs)
    |> Repo.Node.set()
  end

  @doc """
  Deletes a daily_booking.

  ## Examples

      iex> delete_daily_booking(daily_booking)
      {:ok, %DailyBooking{}}

      iex> delete_daily_booking(daily_booking)
      {:error, %Ecto.Changeset{}}

  """
  def delete_daily_booking(id) do
    # Repo.Node.get(DailyBooking, id)
    # |> Repo.Node.delete()

    conn = Neo.conn()
    # Delete the DailyBooking and DailyRent node.
    query =
      "MATCH (n:DailyBooking {uuid: \"#{id}\"})<-[r:BOOK_DAILY]-(m:DailyRent) SET n.delete = true, m.delete = true RETURN n, m"

    _response = Neo.query!(conn, query)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking daily_booking changes.

  ## Examples

      iex> change_daily_booking(daily_booking)
      %Ecto.Changeset{data: %DailyBooking{}}

  """
  def change_daily_booking(%DailyBooking{} = daily_booking, attrs \\ %{}) do
    DailyBooking.changeset(daily_booking, attrs)
  end

  # **********************************************************
  # *                                                        *
  # *                 Monthly Booking                        *
  # *                                                        *
  # **********************************************************

  alias Apartman.Booking.MonthlyBooking

  @doc """
  Returns the list of monthlybookings.

  ## Examples

      iex> list_monthlybookings()
      [%MonthlyBooking{}, ...]

  """
  def list_monthlybookings do
    conn = Neo.conn()
    query = "MATCH (b:MonthlyBooking) WHERE NOT exists(b.delete) RETURN b AS MonthlyBooking"
    response = Neo.query!(conn, query)

    _customers =
      Enum.map(response.results, & &1["MonthlyBooking"])
      |> Enum.map(& &1.properties)
      |> Enum.map(&map_to_absinthe/1)
  end

  @doc """
  Gets a single monthly_booking.

  Raises `Ecto.NoResultsError` if the Monthly booking does not exist.

  ## Examples

      iex> get_monthly_booking!(123)
      %MonthlyBooking{}

      iex> get_monthly_booking!(456)
      ** (Ecto.NoResultsError)

  """
  def get_monthly_booking!(id) do
    Repo.Node.get(MonthlyBooking, id)
  end

  @doc """
  Creates a monthly_booking.

  ## Examples

      iex> create_monthly_booking(%{field: value})
      {:ok, %MonthlyBooking{}}

      iex> create_monthly_booking(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_monthly_booking(attrs \\ %{}) do
    %MonthlyBooking{}
    |> MonthlyBooking.changeset(attrs)
    |> Repo.Node.create()
  end

  @doc """
  Updates a monthly_booking.

  ## Examples

      iex> update_monthly_booking(monthly_booking, %{field: new_value})
      {:ok, %MonthlyBooking{}}

      iex> update_monthly_booking(monthly_booking, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_monthly_booking(%MonthlyBooking{} = monthly_booking, attrs) do
    monthly_booking
    |> MonthlyBooking.changeset(attrs)
    |> Repo.Node.set()
  end

  @doc """
  Deletes a monthly_booking.

  ## Examples

      iex> delete_monthly_booking(monthly_booking)
      {:ok, %MonthlyBooking{}}

      iex> delete_monthly_booking(monthly_booking)
      {:error, %Ecto.Changeset{}}

  """
  def delete_monthly_booking(id) do
    # Repo.Node.get(MonthlyBooking, id)
    # |> Repo.Node.delete()

    conn = Neo.conn()
    # Delete the MonthlyBooking and MonthlyRent node.
    query =
      "MATCH (n:MonthlyBooking {uuid: \"#{id}\"})<-[r:BOOK_MONTHLY]-(m:MonthlyRent) SET n.delete = true, m.delete = true RETURN n, m"

    _response = Neo.query!(conn, query)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking monthly_booking changes.

  ## Examples

      iex> change_monthly_booking(monthly_booking)
      %Ecto.Changeset{data: %MonthlyBooking{}}

  """
  def change_monthly_booking(%MonthlyBooking{} = monthly_booking, attrs \\ %{}) do
    MonthlyBooking.changeset(monthly_booking, attrs)
  end

  # **********************************************************
  # *                                                        *
  # *                    Check-ins                           *
  # *                                                        *
  # **********************************************************

  alias Apartman.Booking.Checkin

  @doc """
  Returns the list of checkins.

  ## Examples

      iex> list_checkins()
      [%Checkin{}, ...]

  """
  def list_checkins do
    conn = Neo.conn()
    query = "MATCH (c:Checkin) WHERE NOT exists(c.delete) RETURN c AS Checkin"
    response = Neo.query!(conn, query)

    _customers =
      Enum.map(response.results, & &1["Checkin"])
      |> Enum.map(& &1.properties)
      |> Enum.map(&map_to_absinthe/1)
  end

  @doc """
  Gets a single checkin.

  Raises `Ecto.NoResultsError` if the Checkin does not exist.

  ## Examples

      iex> get_checkin!(123)
      %Checkin{}

      iex> get_checkin!(456)
      ** (Ecto.NoResultsError)

  """
  def get_checkin!(id) do
    Repo.Node.get(Checkin, id)
  end

  @doc """
  Creates a checkin.

  ## Examples

      iex> create_checkin(%{field: value})
      {:ok, %Checkin{}}

      iex> create_checkin(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_checkin(attrs \\ %{}) do
    %Checkin{}
    |> Checkin.changeset(attrs)
    |> Repo.Node.create()
  end

  @doc """
  Updates a checkin.

  ## Examples

      iex> update_checkin(checkin, %{field: new_value})
      {:ok, %Checkin{}}

      iex> update_checkin(checkin, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_checkin(%Checkin{} = checkin, attrs) do
    checkin
    |> Checkin.changeset(attrs)
    |> Repo.Node.set()
  end

  @doc """
  Deletes a checkin.

  ## Examples

      iex> delete_checkin(checkin)
      {:ok, %Checkin{}}

      iex> delete_checkin(checkin)
      {:error, %Ecto.Changeset{}}

  """
  def delete_checkin(id) do
    # Repo.Node.get(Checkin, id)
    # |> Repo.Node.delete()

    conn = Neo.conn()
    # Delete the Checkin node, and set Room node to 'available'.
    query =
      "MATCH (n:Checkin {uuid: \"#{id}\"})-[r:OCCUPY_DAILY]->(m:Room) SET n.delete = true, m.bOccupied = false DELETE r RETURN n, m"

    _response = Neo.query!(conn, query)

    # Delete DailyRent also, in case of Walk-ins (if Pre-booked, nothing happens)
    query =
      "MATCH (n:Checkin {uuid: \"#{id}\"})<-[:WALKIN_DAILY]-(m:DailyRent) SET m.delete = true RETURN n, m"

    _response = Neo.query!(conn, query)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking checkin changes.

  ## Examples

      iex> change_checkin(checkin)
      %Ecto.Changeset{data: %Checkin{}}

  """
  def change_checkin(%Checkin{} = checkin, attrs \\ %{}) do
    Checkin.changeset(checkin, attrs)
  end

  # **********************************************************
  # *                                                        *
  # *                      Contract                          *
  # *                                                        *
  # **********************************************************

  alias Apartman.Booking.Contract

  @doc """
  Returns the list of contracts.

  ## Examples

      iex> list_contracts()
      [%Contract{}, ...]

  """
  def list_contracts do
    conn = Neo.conn()
    query = "MATCH (c:Contract) WHERE NOT exists(c.delete) RETURN c AS Contract"
    response = Neo.query!(conn, query)

    _customers =
      Enum.map(response.results, & &1["Contract"])
      |> Enum.map(& &1.properties)
      |> Enum.map(&map_to_absinthe/1)
  end

  @doc """
  Gets a single contract.

  Raises `Ecto.NoResultsError` if the Contract does not exist.

  ## Examples

      iex> get_contract!(123)
      %Contract{}

      iex> get_contract!(456)
      ** (Ecto.NoResultsError)

  """
  def get_contract!(id) do
    Repo.Node.get(Contract, id)
  end

  @doc """
  Creates a contract.

  ## Examples

      iex> create_contract(%{field: value})
      {:ok, %Contract{}}

      iex> create_contract(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_contract(attrs \\ %{}) do
    %Contract{}
    |> Contract.changeset(attrs)
    |> Repo.Node.create()
  end

  @doc """
  Updates a contract.

  ## Examples

      iex> update_contract(contract, %{field: new_value})
      {:ok, %Contract{}}

      iex> update_contract(contract, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_contract(%Contract{} = contract, attrs) do
    contract
    |> Contract.changeset(attrs)
    |> Repo.Node.set()
  end

  @doc """
  Deletes a contract.

  ## Examples

      iex> delete_contract(contract)
      {:ok, %Contract{}}

      iex> delete_contract(contract)
      {:error, %Ecto.Changeset{}}

  """
  def delete_contract(id) do
    # Repo.Node.get(Contract, id)
    # |> Repo.Node.delete()

    conn = Neo.conn()
    # Delete the Contract node, and set Room node to 'available'.
    query =
      "MATCH (n:Contract {uuid: \"#{id}\"})-[r:OCCUPY_MONTHLY]->(m:Room) SET n.delete = true, m.bOccupied = false DELETE r RETURN n, m"

    _response = Neo.query!(conn, query)

    # Delete MonthlyRent also, in case of Walk-ins (if Pre-booked, nothing happens)
    query =
      "MATCH (n:Contract {uuid: \"#{id}\"})<-[:WALKIN_MONTHLY]-(m:MonthlyRent) SET m.delete = true RETURN n, m"

    _response = Neo.query!(conn, query)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking contract changes.

  ## Examples

      iex> change_contract(contract)
      %Ecto.Changeset{data: %Contract{}}

  """
  def change_contract(%Contract{} = contract, attrs \\ %{}) do
    Contract.changeset(contract, attrs)
  end
end

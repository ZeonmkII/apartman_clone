defmodule Apartman.Tenant do
  @moduledoc """
  The Tenant context.
  """

  import Ecto.Query, warn: false
  alias Apartman.Repo
  alias Bolt.Sips, as: Neo
  alias Apartman.Tenant.Customer

  defp map_to_absinthe(node) do
    %{
      id: node["uuid"],
      id_number: node["idNumber"],
      first_name: node["firstName"],
      first_name_alt: node["firstNameAlt"],
      last_name: node["lastName"],
      last_name_alt: node["lastNameAlt"],
      date_of_birth: node["dateOfBirth"],
      faith: node["faith"],
      nationality: node["nationality"],
      gender: node["sex"],
      address: node["address"],
      issue_by: node["issueBy"],
      date_of_issue: node["dateOfIssue"],
      date_of_expiry: node["dateOfExpiry"],
      photo: node["photo"],
      phone: node["phone"],
      line: node["line"],
      occupation: node["occupation"],
      emergency_contact: node["emergencyContact"],
      b_current: node["bCurrent"],
      b_tenant: node["bTenant"],
      b_contract: node["bContract"]
    }
  end

  # **********************************************************
  # *                                                        *
  # *                    Customer                            *
  # *                                                        *
  # **********************************************************
  @doc """
  Returns the list of customers.

  ## Examples

      iex> list_customers()
      [%Customer{}, ...]

  """
  def list_customers do
    conn = Neo.conn()
    query = "MATCH (c:Customer) WHERE NOT exists(c.delete) RETURN c AS Customer"
    response = Neo.query!(conn, query)

    _customers =
      Enum.map(response.results, & &1["Customer"])
      |> Enum.map(& &1.properties)
      |> Enum.map(&map_to_absinthe/1)
  end

  @doc """
  Gets a single customer.

  Raises `Ecto.NoResultsError` if the Customer does not exist.

  ## Examples

      iex> get_customer!(123)
      %Customer{}

      iex> get_customer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_customer!(id) do
    Repo.Node.get(Customer, id)
  end

  def get_customer_by_id_number(idNumber) do
    Repo.Node.get_by(Customer, %{idNumber: idNumber})
  end

  @doc """
  Creates a customer.

  ## Examples

      iex> create_customer(%{field: value})
      {:ok, %Customer{}}

      iex> create_customer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_customer(attrs \\ %{}) do
    %Customer{}
    |> Customer.changeset(attrs)
    |> Repo.Node.create()
  end

  @doc """
  Updates a customer.

  ## Examples

      iex> update_customer(customer, %{field: new_value})
      {:ok, %Customer{}}

      iex> update_customer(customer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_customer(%Customer{} = customer, attrs) do
    customer
    |> Customer.changeset(attrs)
    |> Repo.Node.set()
  end

  @doc """
  Deletes a customer.

  ## Examples

      iex> delete_customer(customer)
      {:ok, %Customer{}}

      iex> delete_customer(customer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_customer(id) do
    Repo.Node.get(Customer, id)
    |> Repo.Node.delete()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking customer changes.

  ## Examples

      iex> change_customer(customer)
      %Ecto.Changeset{data: %Customer{}}

  """
  def change_customer(%Customer{} = customer, attrs \\ %{}) do
    Customer.changeset(customer, attrs)
  end

  # Get a random Customer
  def get_one_random_user_id() do
    conn = Neo.conn()
    query = "MATCH (u:User) WHERE NOT exists(u.delete) RETURN u AS User ORDER BY rand() LIMIT 1"
    response = Neo.query!(conn, query)

    _query =
      Enum.map(response.results, & &1["User"])
      |> List.first()

    # if we want only UUID;
    # query.properties["uuid"]
  end

  def list_monthly_bookings_for_customer(id) do
    conn = Neo.conn()

    query =
      "MATCH (c:Customer{idNumber: \"#{id}\"})-->(r:MonthlyRent) MATCH (r)-->(b:MonthlyBooking) WHERE NOT exists(b.delete) RETURN b AS Booking"

    response = Neo.query!(conn, query)

    _bookings = Enum.map(response.results, & &1["Booking"])
  end

  def list_daily_bookings_for_customer(id) do
    conn = Neo.conn()

    query =
      "MATCH (c:Customer{idNumber: \"#{id}\"})-->(r:DailyRent) MATCH (r)-->(b:DailyBooking) WHERE NOT exists(b.delete) RETURN b AS Booking"

    response = Neo.query!(conn, query)

    _bookings = Enum.map(response.results, & &1["Booking"])
  end

  def list_checkins_for_customer(id) do
    conn = Neo.conn()

    query =
      "MATCH (c:Customer{idNumber: \"#{id}\"})-->(r:DailyRent) MATCH (r)-[*1..2]->(k:Checkin) WHERE NOT exists(k.delete) RETURN k AS Checkin"

    response = Neo.query!(conn, query)

    _checkins = Enum.map(response.results, & &1["Checkin"])
  end

  def list_contracts_for_customer(id) do
    conn = Neo.conn()

    query =
      "MATCH (c:Customer{idNumber: \"#{id}\"})-->(r:MonthlyRent) MATCH (r)-[*1..2]->(k:Contract) WHERE NOT exists(k.delete) RETURN k AS Contract"

    response = Neo.query!(conn, query)

    _contracts = Enum.map(response.results, & &1["Contract"])
  end

  # **********************************************************
  # *                                                        *
  # *                   Daily Rent                           *
  # *                                                        *
  # **********************************************************

  alias Apartman.Tenant.DailyRent

  @doc """
  Returns the list of dailyrents.

  ## Examples

      iex> list_dailyrents()
      [%DailyRent{}, ...]

  """
  def list_dailyrents do
    conn = Neo.conn()
    query = "MATCH (d:DailyRent) WHERE NOT exists(d.delete) RETURN d AS DailyRent"
    response = Neo.query!(conn, query)

    _daily_rents =
      Enum.map(response.results, & &1["DailyRent"])
      |> Enum.map(& &1.properties)
      |> Enum.map(&map_to_absinthe/1)
  end

  @doc """
  Gets a single daily_rent.

  Raises `Ecto.NoResultsError` if the Daily rent does not exist.

  ## Examples

      iex> get_daily_rent!(123)
      %DailyRent{}

      iex> get_daily_rent!(456)
      ** (Ecto.NoResultsError)

  """
  def get_daily_rent!(id) do
    Repo.Node.get(DailyRent, id)
  end

  @doc """
  Creates a daily_rent.

  ## Examples

      iex> create_daily_rent(%{field: value})
      {:ok, %DailyRent{}}

      iex> create_daily_rent(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_daily_rent(attrs \\ %{}) do
    %DailyRent{}
    |> DailyRent.changeset(attrs)
    |> Repo.Node.create()
  end

  @doc """
  Updates a daily_rent.

  ## Examples

      iex> update_daily_rent(daily_rent, %{field: new_value})
      {:ok, %DailyRent{}}

      iex> update_daily_rent(daily_rent, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_daily_rent(%DailyRent{} = daily_rent, attrs) do
    daily_rent
    |> DailyRent.changeset(attrs)
    |> Repo.Node.set()
  end

  @doc """
  Deletes a daily_rent.

  ## Examples

      iex> delete_daily_rent(daily_rent)
      {:ok, %DailyRent{}}

      iex> delete_daily_rent(daily_rent)
      {:error, %Ecto.Changeset{}}

  """
  def delete_daily_rent(id) do
    Repo.Node.get(DailyRent, id)
    |> Repo.Node.delete()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking daily_rent changes.

  ## Examples

      iex> change_daily_rent(daily_rent)
      %Ecto.Changeset{data: %DailyRent{}}

  """
  def change_daily_rent(%DailyRent{} = daily_rent, attrs \\ %{}) do
    DailyRent.changeset(daily_rent, attrs)
  end

  # **********************************************************
  # *                                                        *
  # *                  Monthly Rent                          *
  # *                                                        *
  # **********************************************************

  alias Apartman.Tenant.MonthlyRent

  @doc """
  Returns the list of monthlyrents.

  ## Examples

      iex> list_monthlyrents()
      [%MonthlyRent{}, ...]

  """
  def list_monthlyrents do
    conn = Neo.conn()
    query = "MATCH (r:MonthlyRent) WHERE NOT exists(r.delete) RETURN r AS MonthlyRent"
    response = Neo.query!(conn, query)

    _monthly_rents =
      Enum.map(response.results, & &1["MonthlyRent"])
      |> Enum.map(& &1.properties)
      |> Enum.map(&map_to_absinthe/1)
  end

  @doc """
  Gets a single monthly_rent.

  Raises `Ecto.NoResultsError` if the Monthly rent does not exist.

  ## Examples

      iex> get_monthly_rent!(123)
      %MonthlyRent{}

      iex> get_monthly_rent!(456)
      ** (Ecto.NoResultsError)

  """
  def get_monthly_rent!(id) do
    Repo.Node.get(MonthlyRent, id)
  end

  @doc """
  Creates a monthly_rent.

  ## Examples

      iex> create_monthly_rent(%{field: value})
      {:ok, %MonthlyRent{}}

      iex> create_monthly_rent(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_monthly_rent(attrs \\ %{}) do
    %MonthlyRent{}
    |> MonthlyRent.changeset(attrs)
    |> Repo.Node.create()
  end

  @doc """
  Updates a monthly_rent.

  ## Examples

      iex> update_monthly_rent(monthly_rent, %{field: new_value})
      {:ok, %MonthlyRent{}}

      iex> update_monthly_rent(monthly_rent, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_monthly_rent(%MonthlyRent{} = monthly_rent, attrs) do
    monthly_rent
    |> MonthlyRent.changeset(attrs)
    |> Repo.Node.set()
  end

  @doc """
  Deletes a monthly_rent.

  ## Examples

      iex> delete_monthly_rent(monthly_rent)
      {:ok, %MonthlyRent{}}

      iex> delete_monthly_rent(monthly_rent)
      {:error, %Ecto.Changeset{}}

  """
  def delete_monthly_rent(id) do
    Repo.Node.get(MonthlyRent, id)
    |> Repo.Node.delete()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking monthly_rent changes.

  ## Examples

      iex> change_monthly_rent(monthly_rent)
      %Ecto.Changeset{data: %MonthlyRent{}}

  """
  def change_monthly_rent(%MonthlyRent{} = monthly_rent, attrs \\ %{}) do
    MonthlyRent.changeset(monthly_rent, attrs)
  end
end

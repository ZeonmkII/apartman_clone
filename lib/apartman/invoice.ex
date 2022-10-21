defmodule Apartman.Invoice do
  @moduledoc """
  The Invoice context.
  """

  import Ecto.Query, warn: false
  alias Apartman.Repo
  alias Bolt.Sips, as: Neo
  alias Apartman.Invoice.BookingFee

  @doc """
  Convert result from Neo4j (map) into Absinthe prefered format
  """
  def map_to_absinthe(node) do
    %{
      id: node["uuid"],
      booking_fees: node["bookingFees"],
      deposit: node["deposit"],
      advance_payment: node["advancePayment"],
      keycard_fees: node["keycardFees"],
      other_labels: node["otherLabels"],
      other_fees: node["otherFees"],
      bill_cycle: node["billCycle"],
      water_start: node["waterStart"],
      water_end: node["waterEnd"],
      water_unit: node["waterUnit"],
      electric_start: node["electricStart"],
      electric_end: node["electricEnd"]
    }
  end

  # **********************************************************
  # *                                                        *
  # *                  Booking Fees                          *
  # *                                                        *
  # **********************************************************

  @doc """
  Returns the list of bookingfees.

  ## Examples

      iex> list_bookingfees()
      [%BookingFee{}, ...]

  """
  def list_bookingfees do
    conn = Neo.conn()
    query = "MATCH (f:BookingFee) WHERE NOT exists(f.delete) RETURN f AS BookingFee"
    response = Neo.query!(conn, query)

    _bookingfees =
      Enum.map(response.results, & &1["BookingFee"])
      |> Enum.map(& &1.properties)
      |> Enum.map(&map_to_absinthe/1)
  end

  @doc """
  Gets a single booking_fee.

  Raises `Ecto.NoResultsError` if the Booking fee does not exist.

  ## Examples

      iex> get_booking_fee!(123)
      %BookingFee{}

      iex> get_booking_fee!(456)
      ** (Ecto.NoResultsError)

  """
  def get_booking_fee!(id) do
    Repo.Node.get(BookingFee, id)
  end

  @doc """
  Creates a booking_fee.

  ## Examples

      iex> create_booking_fee(%{field: value})
      {:ok, %BookingFee{}}

      iex> create_booking_fee(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_booking_fee(attrs \\ %{}) do
    %BookingFee{}
    |> BookingFee.changeset(attrs)
    |> Repo.Node.create()
  end

  @doc """
  Updates a booking_fee.

  ## Examples

      iex> update_booking_fee(booking_fee, %{field: new_value})
      {:ok, %BookingFee{}}

      iex> update_booking_fee(booking_fee, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_booking_fee(%BookingFee{} = booking_fee, attrs) do
    booking_fee
    |> BookingFee.changeset(attrs)
    |> Repo.Node.set()
  end

  @doc """
  Deletes a booking_fee.

  ## Examples

      iex> delete_booking_fee(booking_fee)
      {:ok, %BookingFee{}}

      iex> delete_booking_fee(booking_fee)
      {:error, %Ecto.Changeset{}}

  """
  def delete_booking_fee(id) do
    Repo.Node.get(BookingFee, id)
    |> Repo.Node.delete()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking booking_fee changes.

  ## Examples

      iex> change_booking_fee(booking_fee)
      %Ecto.Changeset{data: %BookingFee{}}

  """
  def change_booking_fee(%BookingFee{} = booking_fee, attrs \\ %{}) do
    BookingFee.changeset(booking_fee, attrs)
  end

  # **********************************************************
  # *                                                        *
  # *                 Daily Invoice                          *
  # *                                                        *
  # **********************************************************

  alias Apartman.Invoice.DailyInvoice

  @doc """
  Returns the list of dailyinvoices.

  ## Examples

      iex> list_dailyinvoices()
      [%DailyInvoice{}, ...]

  """
  def list_dailyinvoices do
    conn = Neo.conn()
    query = "MATCH (c:DailyInvoice) WHERE NOT exists(c.delete) RETURN c AS DailyInvoice"
    response = Neo.query!(conn, query)

    _dailyinvoices =
      Enum.map(response.results, & &1["DailyInvoice"])
      |> Enum.map(& &1.properties)
      |> Enum.map(&map_to_absinthe/1)
  end

  @doc """
  Gets a single daily_invoice.

  Raises `Ecto.NoResultsError` if the Daily invoice does not exist.

  ## Examples

      iex> get_daily_invoice!(123)
      %DailyInvoice{}

      iex> get_daily_invoice!(456)
      ** (Ecto.NoResultsError)

  """
  def get_daily_invoice!(id) do
    Repo.Node.get(DailyInvoice, id)
  end

  @doc """
  Creates a daily_invoice.

  ## Examples

      iex> create_daily_invoice(%{field: value})
      {:ok, %DailyInvoice{}}

      iex> create_daily_invoice(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_daily_invoice(attrs \\ %{}) do
    %DailyInvoice{}
    |> DailyInvoice.changeset(attrs)
    |> Repo.Node.create()
  end

  @doc """
  Updates a daily_invoice.

  ## Examples

      iex> update_daily_invoice(daily_invoice, %{field: new_value})
      {:ok, %DailyInvoice{}}

      iex> update_daily_invoice(daily_invoice, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_daily_invoice(%DailyInvoice{} = daily_invoice, attrs) do
    daily_invoice
    |> DailyInvoice.changeset(attrs)
    |> Repo.Node.set()
  end

  @doc """
  Deletes a daily_invoice.

  ## Examples

      iex> delete_daily_invoice(daily_invoice)
      {:ok, %DailyInvoice{}}

      iex> delete_daily_invoice(daily_invoice)
      {:error, %Ecto.Changeset{}}

  """
  def delete_daily_invoice(id) do
    Repo.Node.get(DailyInvoice, id)
    |> Repo.Node.delete()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking daily_invoice changes.

  ## Examples

      iex> change_daily_invoice(daily_invoice)
      %Ecto.Changeset{data: %DailyInvoice{}}

  """
  def change_daily_invoice(%DailyInvoice{} = daily_invoice, attrs \\ %{}) do
    DailyInvoice.changeset(daily_invoice, attrs)
  end

  # **********************************************************
  # *                                                        *
  # *                Monthly Invoice                         *
  # *                                                        *
  # **********************************************************

  alias Apartman.Invoice.MonthlyInvoice

  @doc """
  Returns the list of monthlyinvoices.

  ## Examples

      iex> list_monthlyinvoices()
      [%MonthlyInvoice{}, ...]

  """
  def list_monthlyinvoices do
    conn = Neo.conn()
    query = "MATCH (c:MonthlyInvoice) WHERE NOT exists(c.delete) RETURN c AS MonthlyInvoice"
    response = Neo.query!(conn, query)

    _monthlyinvoices =
      Enum.map(response.results, & &1["MonthlyInvoice"])
      |> Enum.map(& &1.properties)
      |> Enum.map(&map_to_absinthe/1)
  end

  @doc """
  Gets a single monthly_invoice.

  Raises `Ecto.NoResultsError` if the Monthly invoice does not exist.

  ## Examples

      iex> get_monthly_invoice!(123)
      %MonthlyInvoice{}

      iex> get_monthly_invoice!(456)
      ** (Ecto.NoResultsError)

  """
  def get_monthly_invoice!(id) do
    Repo.Node.get(MonthlyInvoice, id)
  end

  @doc """
  Creates a monthly_invoice.

  ## Examples

      iex> create_monthly_invoice(%{field: value})
      {:ok, %MonthlyInvoice{}}

      iex> create_monthly_invoice(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_monthly_invoice(attrs \\ %{}) do
    %MonthlyInvoice{}
    |> MonthlyInvoice.changeset(attrs)
    |> Repo.Node.create()
  end

  @doc """
  Updates a monthly_invoice.

  ## Examples

      iex> update_monthly_invoice(monthly_invoice, %{field: new_value})
      {:ok, %MonthlyInvoice{}}

      iex> update_monthly_invoice(monthly_invoice, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_monthly_invoice(%MonthlyInvoice{} = monthly_invoice, attrs) do
    monthly_invoice
    |> MonthlyInvoice.changeset(attrs)
    |> Repo.Node.set()
  end

  @doc """
  Deletes a monthly_invoice.

  ## Examples

      iex> delete_monthly_invoice(monthly_invoice)
      {:ok, %MonthlyInvoice{}}

      iex> delete_monthly_invoice(monthly_invoice)
      {:error, %Ecto.Changeset{}}

  """
  def delete_monthly_invoice(id) do
    Repo.Node.get(MonthlyInvoice, id)
    |> Repo.Node.delete()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking monthly_invoice changes.

  ## Examples

      iex> change_monthly_invoice(monthly_invoice)
      %Ecto.Changeset{data: %MonthlyInvoice{}}

  """
  def change_monthly_invoice(%MonthlyInvoice{} = monthly_invoice, attrs \\ %{}) do
    MonthlyInvoice.changeset(monthly_invoice, attrs)
  end
end

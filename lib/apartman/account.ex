defmodule Apartman.Account do
  @moduledoc """
  The Account context.
  """

  import Ecto.Query, warn: false
  alias Apartman.Repo
  alias Bolt.Sips, as: Neo
  alias Apartman.Account.User

  defp map_to_absinthe(result) do
    %{
      id: result["uuid"],
      user_name: result["userName"],
      first_name: result["firstName"],
      last_name: result["lastName"],
      email: result["email"],
      phone: result["phone"],
      line: result["line"],
      role: result["role"],
      b_active: result["bActive"]
    }
  end

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    conn = Neo.conn()
    query = "MATCH (u:User) WHERE NOT exists(u.delete) RETURN u AS User"
    response = Neo.query!(conn, query)

    _users =
      Enum.map(response.results, & &1["User"])
      |> Enum.map(& &1.properties)
      |> Enum.map(&map_to_absinthe/1)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id) do
    Repo.Node.get(User, id)
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.Node.create()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.updateset(attrs)
    |> Repo.Node.set()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(id) do
    Repo.Node.get(User, id)
    |> Repo.Node.delete()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end

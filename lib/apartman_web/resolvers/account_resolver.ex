defmodule ApartmanWeb.Resolvers.AccountResolver do
  alias Apartman.Account
  alias Apartman.Helper

  def users(_parent, _args, _resolution) do
    {:ok, Account.list_users()}
  end

  def user(_parent, %{id: id}, _resolution) do
    {:ok,
     Account.get_user!(id)
     |> node_to_absinthe()}

    # #  Display errors
    # case Account.get_user!(id) do
    #   nil ->
    #     {:error, "Couldn't find user."}

    #   _ ->
    #     {:ok,
    #      Account.get_user!(id)
    #      |> node_to_absinthe()}
    # end
  end

  def register(_parent, %{input: input}, _resolution) do
    attrs = Helper.map_keys_to_camel(input)

    with {:ok, user} <- Account.create_user(attrs) do
      {:ok, node_to_absinthe(user)}
    else
      {:error, _} -> {:error, "Cannot create user."}
    end
  end

  def update(_parent, %{id: id, input: input}, _resolution) do
    attrs = Helper.map_keys_to_camel(input)
    db_user = Account.get_user!(id)

    with {:ok, user} <- Account.update_user(db_user, attrs) do
      {:ok, node_to_absinthe(user)}
    else
      {:error, _} -> {:error, "Failed to update user data."}
    end
  end

  def delete(_parent, %{id: id}, _resolution) do
    with {:ok, user} <- Account.delete_user(id) do
      {:ok, node_to_absinthe(user)}
    else
      {:error, _} -> {:error, "Couldn't delete user."}
    end
  end

  defp node_to_absinthe(result) do
    case result do
      nil ->
        nil

      _ ->
        %{
          id: result.uuid,
          user_name: result.userName,
          first_name: result.firstName,
          last_name: result.lastName,
          email: result.email,
          phone: result.phone,
          line: result.line,
          role: result.role,
          b_active: result.bActive
        }
    end
  end
end

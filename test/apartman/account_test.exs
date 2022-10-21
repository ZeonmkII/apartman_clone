defmodule Apartman.AccountTest do
  use Apartman.DataCase

  alias Apartman.Account

  describe "users" do
    alias Apartman.Account.User

    @valid_attrs %{bActive: true, email: "some email", firstname: "some firstname", lastname: "some lastname", line: "some line", password: "some password", passwordConfirmation: "some passwordConfirmation", passwordHash: "some passwordHash", phone: "some phone", role: "some role", username: "some username"}
    @update_attrs %{bActive: false, email: "some updated email", firstname: "some updated firstname", lastname: "some updated lastname", line: "some updated line", password: "some updated password", passwordConfirmation: "some updated passwordConfirmation", passwordHash: "some updated passwordHash", phone: "some updated phone", role: "some updated role", username: "some updated username"}
    @invalid_attrs %{bActive: nil, email: nil, firstname: nil, lastname: nil, line: nil, password: nil, passwordConfirmation: nil, passwordHash: nil, phone: nil, role: nil, username: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Account.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Account.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Account.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Account.create_user(@valid_attrs)
      assert user.bActive == true
      assert user.email == "some email"
      assert user.firstname == "some firstname"
      assert user.lastname == "some lastname"
      assert user.line == "some line"
      assert user.password == "some password"
      assert user.passwordConfirmation == "some passwordConfirmation"
      assert user.passwordHash == "some passwordHash"
      assert user.phone == "some phone"
      assert user.role == "some role"
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Account.update_user(user, @update_attrs)
      assert user.bActive == false
      assert user.email == "some updated email"
      assert user.firstname == "some updated firstname"
      assert user.lastname == "some updated lastname"
      assert user.line == "some updated line"
      assert user.password == "some updated password"
      assert user.passwordConfirmation == "some updated passwordConfirmation"
      assert user.passwordHash == "some updated passwordHash"
      assert user.phone == "some updated phone"
      assert user.role == "some updated role"
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_user(user, @invalid_attrs)
      assert user == Account.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Account.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Account.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Account.change_user(user)
    end
  end
end

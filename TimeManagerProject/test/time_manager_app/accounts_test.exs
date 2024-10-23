defmodule TimeManager.AccountsTest do
  use TimeManager.DataCase

  alias TimeManager.Accounts
  alias TimeManager.Accounts.User

  describe "users" do
    import TimeManager.AccountsFixtures

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{email: "test@example.com", username: "testuser", password: "password123"}
      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.email == "test@example.com"
      assert user.username == "testuser"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(%{email: nil, username: nil, password: nil})
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{email: "updated@example.com", username: "updateduser"}
      assert {:ok, %User{} = updated_user} = Accounts.update_user(user, update_attrs)
      assert updated_user.email == "updated@example.com"
      assert updated_user.username == "updateduser"
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "authenticate_user/2 with valid credentials returns ok" do
      user = user_fixture(%{email: "auth@example.com", password: "password123"})
      assert {:ok, authenticated_user} = Accounts.authenticate_user("auth@example.com", "password123")
      assert authenticated_user.id == user.id
    end

    test "authenticate_user/2 with invalid credentials returns error" do
      user_fixture(%{email: "auth@example.com", password: "password123"})
      assert {:error, :invalid_credentials} = Accounts.authenticate_user("auth@example.com", "wrongpassword")
    end
  end
end

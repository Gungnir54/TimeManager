defmodule TimeManager.RightsTest do
  use TimeManager.DataCase

  alias TimeManager.Rights
  alias TimeManager.Rights.Roles
  alias TimeManager.Accounts.User

  import TimeManager.RightsFixtures
  import TimeManager.AccountsFixtures

  describe "roles" do
    @valid_attrs %{rolename: "some rolename"}
    @update_attrs %{rolename: "some updated rolename"}
    @invalid_attrs %{rolename: nil}

    test "list_role/0 returns all roles" do
      roles = roles_fixture()
      assert Rights.list_role() == [roles]
    end

    test "get_roles!/1 returns the roles with given id" do
      roles = roles_fixture()
      assert Rights.get_roles!(roles.id) == roles
    end

    test "create_roles/1 with valid data creates a roles" do
      assert {:ok, %Roles{} = roles} = Rights.create_roles(@valid_attrs)
      assert roles.rolename == "some rolename"
    end

    test "create_roles/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rights.create_roles(@invalid_attrs)
    end

    test "update_roles/2 with valid data updates the roles" do
      roles = roles_fixture()
      assert {:ok, %Roles{} = roles} = Rights.update_roles(roles, @update_attrs)
      assert roles.rolename == "some updated rolename"
    end

    test "update_roles/2 with invalid data returns error changeset" do
      roles = roles_fixture()
      assert {:error, %Ecto.Changeset{}} = Rights.update_roles(roles, @invalid_attrs)
      assert roles == Rights.get_roles!(roles.id)
    end

    test "delete_roles/1 deletes the roles" do
      roles = roles_fixture()
      assert {:ok, %Roles{}} = Rights.delete_roles(roles)
      assert_raise Ecto.NoResultsError, fn -> Rights.get_roles!(roles.id) end
    end

    test "change_roles/1 returns a roles changeset" do
      roles = roles_fixture()
      assert %Ecto.Changeset{} = Rights.change_roles(roles)
    end

    test "upgrade_user_role/2 upgrades a user's role" do
      user = user_fixture()
      new_role = roles_fixture()
      assert {:ok, %User{} = updated_user} = Rights.upgrade_user_role(user, new_role)
      assert updated_user.role_id == new_role.id
    end
  end
end

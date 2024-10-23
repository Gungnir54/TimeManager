defmodule TimeManager.AccountsFixtures do
  alias TimeManager.Accounts
  alias TimeManager.Rights

  def user_fixture(attrs \\ %{}) do
    role = role_fixture()

    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "user#{System.unique_integer()}@example.com",
        username: "user#{System.unique_integer()}",
        password: "password123",
        role_id: role.id
      })
      |> Accounts.create_user()

    user
  end

  def role_fixture(attrs \\ %{}) do
    {:ok, role} =
      attrs
      |> Enum.into(%{
        rolename: "employee"
      })
      |> Rights.create_roles()

    role
  end
end

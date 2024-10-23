defmodule TimeManager.RightsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManager.Rights` context.
  """

  @doc """
  Generate a roles.
  """
  def roles_fixture(attrs \\ %{}) do
    {:ok, roles} =
      attrs
      |> Enum.into(%{
        rolename: "some rolename"
      })
      |> TimeManager.Rights.create_roles()

    roles
  end
end

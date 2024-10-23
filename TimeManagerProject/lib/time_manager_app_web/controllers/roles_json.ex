defmodule TimeManagerWeb.RolesJSON do
  alias TimeManager.Rights.Roles

  @doc """
  Renders a list of role.
  """
  def index(%{role: role}) do
    %{data: for(roles <- role, do: data(roles))}
  end

  @doc """
  Renders a single roles.
  """
  def show(%{roles: roles}) do
    %{data: data(roles)}
  end

  defp data(%Roles{} = roles) do
    %{
      id: roles.id,
      rolename: roles.rolename
    }
  end
end

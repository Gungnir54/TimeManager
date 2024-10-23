defmodule TimeManagerWeb.UserJSON do
  alias TimeManager.Accounts.User

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  def index_with_clocks(%{users: users}) do
    %{data: for(user <- users, do: data_with_clocks(user))}
  end

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    %{data: data(user)}
  end

  def show_full(%{user: user}) do
    %{data: data_full(user)}
  end

  def show_with_clocks(%{user: user}) do
    %{data: data_with_clocks(user)}
  end

  def show_with_clocks_and_workingtimes(%{user: user}) do
    %{data: data_with_clocks_and_workingtimes(user)}
  end

  def index_with_clocks(%{users: users}) do
    %{data: for(user <- users, do: data_with_clocks(user))}
  end

  def index_with_clocks_and_workingtimes(%{users: users}) do
    %{data: for(user <- users, do: data_with_clocks_and_workingtimes(user))}
  end

  def data(%User{} = user) do
    %{
      id: user.id,
      username: user.username,
      email: user.email,
      role: user.role && %{id: user.role.id, rolename: user.role.rolename},
      teams: Enum.map(user.teams, &%{id: &1.id, name: &1.name})
    }
  end

  defp data_full(%User{} = user) do
    %{
      id: user.id,
      username: user.username,
      email: user.email,
      role: user.role && %{id: user.role.id, rolename: user.role.rolename},
      teams: Enum.map(user.teams, &%{id: &1.id, name: &1.name}),
      clocks: Enum.map(user.clocks, &%{id: &1.id, time: &1.time, status: &1.status}),
      workingtimes: Enum.map(user.workingtimes, &%{id: &1.id, start: &1.start, end: &1.end})
    }
  end

  defp data_with_clocks(%User{} = user) do
    %{
      id: user.id,
      username: user.username,
      email: user.email,
      role: user.role && %{id: user.role.id, rolename: user.role.rolename},
      teams: Enum.map(user.teams, &%{id: &1.id, name: &1.name}),
      clocks: Enum.map(user.clocks, &%{id: &1.id, time: &1.time, status: &1.status})
    }
  end

  defp data_with_clocks_and_workingtimes(%User{} = user) do
    %{
      id: user.id,
      username: user.username,
      email: user.email,
      role: user.role && %{id: user.role.id, rolename: user.role.rolename},
      teams: Enum.map(user.teams, &%{id: &1.id, name: &1.name}),
      clocks: Enum.map(user.clocks, &%{id: &1.id, time: &1.time, status: &1.status}),
      workingtimes: Enum.map(user.workingtimes, &%{id: &1.id, start: &1.start, end: &1.end})
    }
  end
end

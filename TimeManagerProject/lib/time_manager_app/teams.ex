defmodule TimeManager.Teams do
  @moduledoc """
  The Teams context.
  """

  import Ecto.Query, warn: false
  alias TimeManager.Repo

  alias TimeManager.Teams.Team
  alias TimeManager.Accounts.User

  @doc """
  Returns the list of teams.

  ## Examples

      iex> list_teams()
      [%Team{}, ...]

  """
  def list_teams do
    Team
    |> preload(users: [:role])
    |> order_by([t], asc: t.name)
    |> Repo.all()
  end

  @doc """
  Gets a single team.

  Raises `Ecto.NoResultsError` if the Team does not exist.

  ## Examples

      iex> get_team!(123)
      %Team{}

      iex> get_team!(456)
      ** (Ecto.NoResultsError)

  """
  def get_team!(id) do
    Repo.get!(Team, id)
    |> Repo.preload(users: [:role])
  end

  @doc """
  Creates a team.

  ## Examples

      iex> create_team(%{field: value})
      {:ok, %Team{}}

      iex> create_team(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_team(attrs \\ %{}) do
      # Charger les utilisateurs par leurs IDs
    users =
      attrs["users"]
      |> Enum.map(&Repo.get!(TimeManager.Accounts.User, &1)) # Utiliser uniquement les IDs des utilisateurs

    # Créer l'équipe et associer les utilisateurs
    %Team{}
    |> Team.changeset(Map.put(attrs, "users", users))  # Associer les utilisateurs par leurs objets
    |> Repo.insert()
    |> case do
      {:ok, team} ->
        {:ok, Repo.preload(team, :users)}  # Précharger les utilisateurs pour renvoyer l'équipe complète
      error ->
        error
    end
  end

  @doc """
  Updates a team.

  ## Examples

      iex> update_team(team, %{field: new_value})
      {:ok, %Team{}}

      iex> update_team(team, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_team(%Team{} = team, attrs) do
    team
    |> Team.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a team.

  ## Examples

      iex> delete_team(team)
      {:ok, %Team{}}

      iex> delete_team(team)
      {:error, %Ecto.Changeset{}}

  """
  def delete_team(%Team{} = team) do
    Repo.delete(team)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking team changes.

  ## Examples

      iex> change_team(team)
      %Ecto.Changeset{data: %Team{}}

  """
  def change_team(%Team{} = team, attrs \\ %{}) do
    Team.changeset(team, attrs)
  end

  @doc """
  Returns the list of users for a team.

  ## Examples

      iex> get_team_users(123)
      [%User{}, ...]

  """
  def get_team_users(team_id) do
    team = Repo.get!(Team, team_id)
    Repo.preload(team, :users)
  end

  def add_user_to_team(%User{} = user, %Team{} = team) do
    case Repo.get_by(TimeManager.TeamsUsers, user_id: user.id, team_id: team.id) do
      nil ->
        Ecto.Multi.new()
        |> Ecto.Multi.insert(:teams_users, TimeManager.TeamsUsers.changeset(%TimeManager.TeamsUsers{}, %{user_id: user.id, team_id: team.id}))
        |> Ecto.Multi.run(:team, fn _, _ ->
          {:ok, Repo.preload(team, [users: [:role]], force: true)}
        end)
        |> Repo.transaction()
        |> case do
          {:ok, %{team: updated_team}} -> {:ok, updated_team}
          {:error, _, changeset, _} -> {:error, changeset}
        end
      _existing ->
        {:error, :user_already_in_team}
    end
  end

  def remove_user_from_team(%User{} = user, %Team{} = team) do
    case Repo.get_by(TimeManager.TeamsUsers, user_id: user.id, team_id: team.id) do
      nil ->
        {:error, :user_not_in_team}
      teams_users ->
        Ecto.Multi.new()
        |> Ecto.Multi.delete(:teams_users, teams_users)
        |> Ecto.Multi.run(:team, fn _, _ ->
          {:ok, Repo.preload(team, [users: [:role]], force: true)}
        end)
        |> Repo.transaction()
        |> case do
          {:ok, %{team: updated_team}} -> {:ok, updated_team}
          {:error, _, changeset, _} -> {:error, changeset}
        end
    end
  end

  def list_teams_with_users_and_roles do
    Repo.all(Team)
    |> Repo.preload(users: [:role])
  end
end

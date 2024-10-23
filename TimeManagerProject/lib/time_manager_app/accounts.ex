defmodule TimeManager.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias TimeManager.Repo
  alias TimeManager.Rights.Roles
  alias TimeManager.Accounts.User
  alias TimeManager.Teams.Team
  @doc """
  Returns the list of users.
  """
  def list_users do
    from(u in User,
      preload: [:role, teams: [:users]],
      order_by: [asc: u.username]
    )
    |> Repo.all()
    |> IO.inspect(label: "Users with preloaded role and teams")
  end

  @doc """
  Gets a single user and preloads teams and roles.
  """
  def get_user!(id) do
    Repo.get!(User, id)
    |> Repo.preload([:role, teams: [:users]])
  end

  @doc """
  Creates a user.
  """
  def create_user(attrs) do
    IO.inspect(attrs, label: "Attributes received in create_user")

    %User{}
    |> User.changeset(attrs)
    |> IO.inspect(label: "Changeset before insertion")
    |> Repo.insert()
    |> case do
      {:ok, user} ->
        IO.inspect(user, label: "User successfully created")
        {:ok, user}
      {:error, changeset} ->
        IO.inspect(changeset, label: "Error in create_user")
        {:error, changeset}
    end
  end

  @doc """
  Updates a user.
  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.
  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Removes a user from a team.
  """
  def remove_user_from_team(%User{} = user, %Team{} = team) do
    user
    |> Repo.preload(:teams)
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:teams, Enum.reject(user.teams, &(&1.id == team.id)))
    |> Repo.update()
  end

  def authenticate_user(email, password) do
  user = Repo.get_by(User, email: email)

    if user && Bcrypt.verify_pass(password, user.hashed_password) do
      {:ok, user}
    else
      {:error, :invalid_credentials}
    end
  end

  def get_role_by_name(rolename) do
    Repo.get_by(Roles, rolename: rolename)
  end

end

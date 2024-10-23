defmodule TimeManager.Rights do
  @moduledoc """
  The Rights context.
  """

  import Ecto.Query, warn: false
  alias TimeManager.Repo

  alias TimeManager.Rights.Roles
  alias TimeManager.Accounts.User

  @doc """
  Returns the list of role.

  ## Examples

      iex> list_role()
      [%Roles{}, ...]

  """
  def list_role do
    Repo.all(Roles)
  end

  @doc """
  Gets a single roles.

  Raises `Ecto.NoResultsError` if the Roles does not exist.

  ## Examples

      iex> get_roles!(123)
      %Roles{}

      iex> get_roles!(456)
      ** (Ecto.NoResultsError)

  """
  def get_roles!(id), do: Repo.get!(Roles, id)

  @doc """
  Creates a roles.

  ## Examples

      iex> create_roles(%{field: value})
      {:ok, %Roles{}}

      iex> create_roles(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_roles(attrs \\ %{}) do
    %Roles{}
    |> Roles.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a roles.

  ## Examples

      iex> update_roles(roles, %{field: new_value})
      {:ok, %Roles{}}

      iex> update_roles(roles, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_roles(%Roles{} = roles, attrs) do
    roles
    |> Roles.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a roles.

  ## Examples

      iex> delete_roles(roles)
      {:ok, %Roles{}}

      iex> delete_roles(roles)
      {:error, %Ecto.Changeset{}}

  """
  def delete_roles(%Roles{} = roles) do
    Repo.delete(roles)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking roles changes.

  ## Examples

      iex> change_roles(roles)
      %Ecto.Changeset{data: %Roles{}}

  """
  def change_roles(%Roles{} = roles, attrs \\ %{}) do
    Roles.changeset(roles, attrs)
  end

  @doc """
  Upgrades a user role.
  """
  def upgrade_user_role(%TimeManager.Accounts.User{} = user, %TimeManager.Rights.Roles{} = role) do
    user
    |> Ecto.Changeset.change(%{role_id: role.id})
    |> Repo.update()
  end
end

defmodule TimeManagerWeb.UserController do
  use TimeManagerWeb, :controller

  alias TimeManager.Accounts
  alias TimeManager.Accounts.User

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users() |> TimeManager.Repo.preload(:role) |> TimeManager.Repo.preload(:teams)
    render(conn, :index, users: users)
  end

  def index_with_clocks(conn, _params) do
    users = Accounts.list_users()
      |> TimeManager.Repo.preload([:role, :teams, :clocks])
    render(conn, :index_with_clocks, users: users)
  end

  def create(conn, %{"username" => username, "email" => email, "password" => password} = params) do
    default_role = Accounts.get_role_by_name("employee")
    role_id = Map.get(params, "role_id", default_role.id)
    attrs = Map.merge(Map.take(params, ["username", "email", "password"]), %{"role_id" => role_id})

    IO.inspect(attrs, label: "User creation attributes")

    case Accounts.create_user(attrs) do
      {:ok, user} ->
        IO.inspect(user, label: "Created user")
        user = TimeManager.Repo.preload(user, [:role, :teams, :clocks, :workingtimes])
        {:ok, token} = TimeManagerWeb.JWTHelper.create_token(user)
        conn
        |> put_status(:created)
        |> put_resp_header("authorization", "Bearer " <> token)
        |> json(%{user: user, token: token})

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset, label: "Changeset errors")
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: changeset_errors(changeset)})

      error ->
        IO.inspect(error, label: "Unexpected error")
        conn
        |> put_status(:internal_server_error)
        |> json(%{error: "An unexpected error occurred"})
    end
  end

  def login(conn, %{"email" => email, "password" => password}) do
    case Accounts.authenticate_user(email, password) do
      {:ok, user} ->

        {:ok, token} = TimeManagerWeb.JWTHelper.create_token(user)

        conn
        |> put_status(:ok)
        |> put_resp_header("authorization", "Bearer " <> token)
        |> json(%{message: "Login successful", token: token})

      {:error, :invalid_credentials} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid email or password"})
    end
  end

  defp changeset_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
      |> TimeManager.Repo.preload([:role, :teams, :clocks, :workingtimes])
    render(conn, :show_full, user: user)
  end

  def show_with_clocks(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
      |> TimeManager.Repo.preload([:role, :teams, :clocks])
    render(conn, :show_with_clocks, user: user)
  end

  def show_with_clocks_and_workingtimes(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
      |> TimeManager.Repo.preload([:role, :teams, :clocks, :workingtimes])
    render(conn, :show_with_clocks_and_workingtimes, user: user)
  end

  def index_with_clocks_and_workingtimes(conn, _params) do
    users = Accounts.list_users()
      |> TimeManager.Repo.preload([:role, :teams, :clocks, :workingtimes])
    render(conn, :index_with_clocks_and_workingtimes, users: users)
  end

  def get_user_teams(conn, %{"id" => id}) do
    user_teams = Accounts.get_user_teams(id)
    render(conn, :user_teams, teams: user_teams)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = updated_user} <- Accounts.update_user(user, user_params) do
      updated_user = TimeManager.Repo.preload(updated_user, [:role, :teams])
      render(conn, :show, user: updated_user)
    end
  end

  def add_role_to_user(conn, %{"user_id" => user_id, "role_id" => role_id}) do
    user = Accounts.get_user!(user_id)
    role = Accounts.get_role!(role_id)

    case Accounts.add_role_to_user(user, role) do
      {:ok, user} ->
        render(conn, "show.json", user: user)
      {:error, reason} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: reason})
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id) |> TimeManager.Repo.preload(:role)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end

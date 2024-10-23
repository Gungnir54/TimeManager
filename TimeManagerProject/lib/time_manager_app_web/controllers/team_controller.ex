defmodule TimeManagerWeb.TeamController do
  use TimeManagerWeb, :controller

  alias TimeManager.Teams
  alias TimeManager.Accounts
  alias TimeManager.Teams.Team
  alias TimeManager.Accounts.User
  alias TimeManagerWeb.Router.Helpers, as: Routes
  alias TimeManager.Repo

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, _params) do
    teams = Teams.list_teams_with_users_and_roles()
    render(conn, :index, teams: teams)
  end

  def create(conn, %{"team" => team_params}) do
    case Teams.create_team(team_params) do
      {:ok, team} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", ~p"/api/teams/#{team.id}")
        |> render(:show, team: team)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(json: TimeManagerWeb.ChangesetJSON)
        |> render(:error, changeset: changeset)
    end
  end

  def add_user_to_team(conn, %{"team_id" => team_id, "user_id" => user_id}) do
    team = Teams.get_team!(team_id)
    user = Accounts.get_user!(user_id) |> TimeManager.Repo.preload(:role)
    case Teams.add_user_to_team(user, team) do
      {:ok, updated_team} ->
        updated_team = TimeManager.Repo.preload(updated_team, users: [:role])
        render(conn, :show, team: updated_team)
      {:error, :user_already_in_team} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(json: TimeManagerWeb.ErrorJSON)
        |> render("422.json", %{errors: %{user: ["est déjà dans l'équipe"]}})
      {:error, _changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(json: TimeManagerWeb.ErrorJSON)
        |> render("422.json", %{errors: %{user: ["n'a pas pu être ajouté à l'équipe"]}})
    end
  end

  def show(conn, %{"id" => id}) do
    team = Teams.get_team!(id) |> TimeManager.Repo.preload(users: [:role])
    render(conn, :show, team: team)
  end

  def get_team_users(conn, %{"id" => id}) do
    team_users = Teams.get_team_users(id)
    render(conn, :team_users, users: team_users)
  end

  def update(conn, %{"id" => id, "team" => team_params}) do
    team = Teams.get_team!(id)

    with {:ok, %Team{} = team} <- Teams.update_team(team, team_params) do
      render(conn, :show, team: team)
    end
  end

  def delete(conn, %{"id" => id}) do
    team = Teams.get_team!(id)

    with {:ok, %Team{}} <- Teams.delete_team(team) do
      send_resp(conn, :no_content, "")
    end
  end

  def remove_user_from_team(conn, %{"team_id" => team_id, "user_id" => user_id}) do
    team = Teams.get_team!(team_id)
    user = Accounts.get_user!(user_id) |> TimeManager.Repo.preload(:role)
    case Teams.remove_user_from_team(user, team) do
      {:ok, updated_team} ->
        updated_team = TimeManager.Repo.preload(updated_team, users: [:role])
        render(conn, :show, team: updated_team)
      {:error, :user_not_in_team} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(json: TimeManagerWeb.ErrorJSON)
        |> render("422.json", %{errors: %{user: ["n'est pas dans l'équipe"]}})
      {:error, _changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(json: TimeManagerWeb.ErrorJSON)
        |> render("422.json", %{errors: %{user: ["n'a pas pu être retiré de l'équipe"]}})
    end
  end
end

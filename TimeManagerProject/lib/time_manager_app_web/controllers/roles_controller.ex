defmodule TimeManagerWeb.RolesController do
  use TimeManagerWeb, :controller

  alias TimeManager.Rights
  alias TimeManager.Rights.Roles
  alias TimeManager.Accounts

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, _params) do
    role = Rights.list_role()
    render(conn, :index, role: role)
  end

  def create(conn, %{"rolename" => rolename} = params) do
    attrs = Map.take(params, ["rolename"])

    case Rights.create_roles(attrs) do
      {:ok, roles} ->
        conn
        |> put_status(:created)
        |> json(roles)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: changeset_errors(changeset)})
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
    roles = Rights.get_roles!(id)
    render(conn, :show, roles: roles)
  end

  def update(conn, %{"id" => id} = params) do
    roles = Rights.get_roles!(id)
    roles_params = Map.take(params, ["rolename"])

    with {:ok, %Roles{} = updated_roles} <- Rights.update_roles(roles, roles_params) do
      render(conn, :show, roles: updated_roles)
    end
  end

  def update_user_role(conn, %{"user_id" => user_id, "role_id" => role_id}) do
    user = Accounts.get_user!(user_id)
    role = Rights.get_roles!(role_id)

    case Rights.upgrade_user_role(user, role) do
      {:ok, updated_user} ->
        updated_user = TimeManager.Repo.preload(updated_user, [:role, :teams])
        render(conn, TimeManagerWeb.UserJSON, :show, user: updated_user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(json: TimeManagerWeb.ErrorJSON)
        |> render("422.json", %{errors: changeset})
    end
  end

  def delete(conn, %{"id" => id}) do
    roles = Rights.get_roles!(id)

    with {:ok, %Roles{}} <- Rights.delete_roles(roles) do
      send_resp(conn, :no_content, "")
    end
  end
end

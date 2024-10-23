defmodule TimeManagerWeb.ClocksController do
  use TimeManagerWeb, :controller

  alias TimeManager.Clocking
  alias TimeManager.Clocking.Clocks

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, %{"user_id" => user_id}) do
    clocks = Clocking.list_clocks_for_user(user_id)
    json(conn, clocks)
  end

  def create(conn, %{"user_id" => user_id, "clock" => %{"time" => time, "status" => status}}) do
    case Clocking.create_clocks(%{"time" => time, "status" => status, "user_id" => user_id}) do
      {:ok, clock} ->
        conn
        |> put_status(:created)
        |> json(clock)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: changeset_errors(changeset)})
    end
  end

  defp changeset_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      # Utilisez la fonction de localisation si nécessaire
      Ecto.Changeset.humanize_error(msg, opts)
    end)
  end

  def show(conn, %{"clock_id" => clock_id}) do
    clock = Clocking.get_clocks!(clock_id)
    json(conn, clock)
  end

  def update(conn, %{"clock_id" => clock_id, "clock" => clocks_params}) do
    clock = Clocking.get_clocks!(clock_id)

    with {:ok, %Clocks{} = updated_clocks} <- Clocking.update_clocks(clock, clocks_params) do
      json(conn, clock)
    end
  end

  def delete(conn, %{"clock_id" => clock_id}) do
    clocks = Clocking.get_clocks!(clock_id)

    with {:ok, %Clocks{}} <- Clocking.delete_clocks(clocks) do
      send_resp(conn, :no_content, "")
    end
  end
end

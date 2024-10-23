defmodule TimeManagerWeb.WorkingtimeController do
  use TimeManagerWeb, :controller

  alias TimeManager.Time
  alias TimeManager.Time.Workingtime

  action_fallback TimeManagerWeb.FallbackController

  # GET /api/workingtime/:userID?start=XXX&end=YYY
  def index(conn, %{"user_id" => user_id, "start" => start, "end" => end_time}) do
    workingtimes = Time.list_workingtimes_by_user_and_date(user_id, start, end_time)
    json(conn, workingtimes)
  end

  # GET /api/workingtime/:userID/:id
  def show(conn, %{"user_id" => user_id, "id" => id}) do
    workingtime = Time.get_workingtime_by_user!(user_id, id)
    json(conn, workingtime)
  end

  # POST /api/workingtime/:userID
  def create(conn, %{"user_id" => user_id, "time" => %{"start" => start, "end" => end_time}}) do
    case Time.create_workingtime(%{"start" => start, "end" => end_time, "user_id" => user_id}) do
      {:ok, time} ->
        conn
        |> put_status(:created)
        |> json(time)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: changeset_errors(changeset)})
    end
  end

  # PUT /api/workingtime/:id
  def update(conn, %{"id" => id, "time" => workingtime_params}) do
    workingtime = Time.get_workingtime!(id)

    with {:ok, %Workingtime{} = updated_workingtime} <- Time.update_workingtime(workingtime, workingtime_params) do
      json(conn, updated_workingtime)
    end
  end

  # DELETE /api/workingtime/:id
  def delete(conn, %{"id" => id}) do
    workingtime = Time.get_workingtime!(id)

    with {:ok, %Workingtime{}} <- Time.delete_workingtime(workingtime) do
      send_resp(conn, :no_content, "")
    end
  end

  # Helper function for changeset errors
  defp changeset_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end

defmodule TimeManager.Time do
  @moduledoc """
  The Time context.
  """

  import Ecto.Query, warn: false
  alias TimeManager.Repo
  alias TimeManager.Time.Workingtime

  # Existant: Récupère tous les workingtimes
  def list_workingtimes do
    Repo.all(Workingtime)
  end

  # Nouvelle fonction : Récupère les workingtimes d'un utilisateur dans une plage de dates
  def list_workingtimes_by_user_and_date(user_id, start_date, end_date) do
    query =
      from w in Workingtime,
           where: w.user_id == ^user_id and w.start >= ^start_date and w.end <= ^end_date,
           order_by: [asc: w.start]

    Repo.all(query)
  end

  # Fonction pour récupérer un workingtime spécifique d'un utilisateur
  def get_workingtime_by_user!(user_id, workingtime_id) do
    Repo.get_by!(Workingtime, id: workingtime_id, user_id: user_id)
  end

  # Existant: Récupère un seul workingtime par son ID
  def get_workingtime!(id), do: Repo.get!(Workingtime, id)

  # Existant: Crée un workingtime
  def create_workingtime(attrs \\ %{}) do
    %Workingtime{}
    |> Workingtime.changeset(attrs)
    |> Repo.insert()
  end

  # Existant: Met à jour un workingtime
  def update_workingtime(%Workingtime{} = workingtime, attrs) do
    workingtime
    |> Workingtime.changeset(attrs)
    |> Repo.update()
  end

  # Existant: Supprime un workingtime
  def delete_workingtime(%Workingtime{} = workingtime) do
    Repo.delete(workingtime)
  end

  # Existant: Crée un changeset pour le tracking des modifications
  def change_workingtime(%Workingtime{} = workingtime, attrs \\ %{}) do
    Workingtime.changeset(workingtime, attrs)
  end
end

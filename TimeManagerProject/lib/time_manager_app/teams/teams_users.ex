defmodule TimeManager.TeamsUsers do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams_users" do
    belongs_to :user, TimeManager.Accounts.User
    belongs_to :team, TimeManager.Teams.Team
  end

  def changeset(teams_users, attrs) do
    teams_users
    |> cast(attrs, [:user_id, :team_id])
    |> validate_required([:user_id, :team_id])
    |> unique_constraint([:user_id, :team_id])
  end
end

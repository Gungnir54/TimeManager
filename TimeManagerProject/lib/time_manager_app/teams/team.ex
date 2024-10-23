defmodule TimeManager.Teams.Team do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :name, :users]}
  schema "teams" do
    field :name, :string
    many_to_many :users, TimeManager.Accounts.User, join_through: "teams_users", on_delete: :delete_all

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> put_assoc(:users, Map.get(attrs, "users", []))
  end
end

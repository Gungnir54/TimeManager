defmodule TimeManager.Time.Workingtime do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :start, :end, :user_id, :inserted_at, :updated_at]}
  schema "workingtimes" do
    field :end, :naive_datetime
    field :start, :naive_datetime
    belongs_to :user, TimeManager.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(workingtime, attrs) do
    workingtime
    |> cast(attrs, [:start, :end, :user_id])
    |> validate_required([:start, :end])
  end
end

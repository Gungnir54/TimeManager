defmodule TimeManager.Clocking.Clocks do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :status, :time, :user_id]}
  schema "clock" do
    field :status, :boolean, default: false
    field :time, :naive_datetime
    belongs_to :user, TimeManager.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(clocks, attrs) do
    clocks
    |> cast(attrs, [:time, :status, :user_id])
    |> validate_required([:time, :status])
  end
end

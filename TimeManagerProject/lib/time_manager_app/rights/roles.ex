defmodule TimeManager.Rights.Roles do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:rolename]}
  schema "roles" do
    field :rolename, :string
    has_many :users, TimeManager.Accounts.User, on_delete: :delete_all

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(roles, attrs) do
    roles
    |> cast(attrs, [:rolename])
    |> validate_required([:rolename])
  end
end

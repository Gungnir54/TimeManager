defmodule TimeManager.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :email, :username, :role, :teams, :clocks, :workingtimes]}
  schema "users" do
    field :email, :string
    field :username, :string
    field :password, :string, virtual: true
    field :hashed_password, :string
    belongs_to :role, TimeManager.Rights.Roles
    many_to_many :teams, TimeManager.Teams.Team, join_through: "teams_users", on_delete: :delete_all
    has_many :clocks, TimeManager.Clocking.Clocks
    has_many :workingtimes, TimeManager.Time.Workingtime

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password, :role_id])
    |> validate_required([:username, :email])
    |> maybe_validate_password(attrs)
    |> hash_password()
  end

    # Cette fonction conditionne la validation du mot de passe à sa présence
  defp maybe_validate_password(changeset, attrs) do
    if Map.has_key?(attrs, "password") and attrs["password"] != nil do
      changeset
      |> validate_required([:password])
      |> validate_length(:password, min: 6)
    else
      changeset
    end
  end

  defp hash_password(changeset) do
    case get_change(changeset, :password) do
      nil ->
        changeset

      password ->
        put_change(changeset, :hashed_password, Bcrypt.hash_pwd_salt(password))
    end
  end
end

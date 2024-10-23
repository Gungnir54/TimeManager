defmodule TimeManager.Repo.Migrations.GeneralMigration do
  use Ecto.Migration

  def change do
    # Création de la table roles
    create table(:roles) do
      add :rolename, :string

      timestamps(type: :utc_datetime)
    end

    # Création de la table teams
    create table(:teams) do
      add :name, :string

      timestamps(type: :utc_datetime)
    end

    # Création de la table users avec références à la table roles et à la table teams
    create table(:users) do
      add :username, :string
      add :email, :string
      add :hashed_password, :string, null: false
      add :role_id, references(:roles, on_delete: :nothing), null: true  # role_id est optionnel

      timestamps(type: :utc_datetime)
    end

    # Ajout d'index uniques sur username et email
    create unique_index(:users, [:username])
    create unique_index(:users, [:email])

    # Création de la table teams_users avec références à la table users et à la table teams
    create table(:teams_users) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :team_id, references(:teams, on_delete: :delete_all)
    end

    create unique_index(:teams_users, [:user_id, :team_id])  # Assure que l'association est unique

    # Création de la table workingtimes avec références à la table users
    create table(:workingtimes) do
      add :start, :naive_datetime
      add :end, :naive_datetime
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    # Création de la table clock avec références à la table users
    create table(:clock) do
      add :time, :naive_datetime
      add :status, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end
  end
end

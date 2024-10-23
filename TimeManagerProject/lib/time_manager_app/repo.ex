defmodule TimeManager.Repo do
  use Ecto.Repo,
    otp_app: :time_manager_app,
    adapter: Ecto.Adapters.Postgres
end

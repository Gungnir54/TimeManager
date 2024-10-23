defmodule TimeManager.TimeFixtures do
  alias TimeManager.Time
  import TimeManager.AccountsFixtures

  def workingtime_fixture(attrs \\ %{}) do
    user = attrs[:user] || user_fixture()

    {:ok, workingtime} =
      attrs
      |> Enum.into(%{
        start: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second),
        end: NaiveDateTime.utc_now() |> NaiveDateTime.add(3600) |> NaiveDateTime.truncate(:second),
        user_id: user.id
      })
      |> Time.create_workingtime()

    workingtime
  end
end

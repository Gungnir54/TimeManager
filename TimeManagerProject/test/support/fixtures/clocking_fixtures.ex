defmodule TimeManager.ClockingFixtures do
  alias TimeManager.Clocking
  import TimeManager.AccountsFixtures

  def clocks_fixture(attrs \\ %{}) do
    user = attrs[:user] || user_fixture()

    {:ok, clocks} =
      attrs
      |> Enum.into(%{
        status: true,
        time: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second),
        user_id: user.id
      })
      |> Clocking.create_clocks()

    clocks
  end
end

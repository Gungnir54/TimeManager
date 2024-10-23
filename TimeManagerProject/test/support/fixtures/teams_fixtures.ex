defmodule TimeManager.TeamsFixtures do
  alias TimeManager.Teams
  import TimeManager.AccountsFixtures

  def team_fixture(attrs \\ %{}) do
    user = user_fixture()
    {:ok, team} =
      attrs
      |> Enum.into(%{
        name: "Team #{System.unique_integer()}",
        users: [user.id]
      })
      |> Teams.create_team()

    team
  end
end

defmodule TimeManager.TeamsTest do
  use TimeManager.DataCase

  alias TimeManager.Teams
  alias TimeManager.Teams.Team
  alias TimeManager.Accounts.User

  import TimeManager.TeamsFixtures
  import TimeManager.AccountsFixtures

  describe "teams" do
    @valid_attrs %{name: "some team name"}
    @update_attrs %{name: "some updated team name"}
    @invalid_attrs %{name: nil}

    test "list_teams/0 returns all teams" do
      team = team_fixture()
      assert Teams.list_teams() == [team]
    end

    test "get_team!/1 returns the team with given id" do
      team = team_fixture()
      assert Teams.get_team!(team.id) == team
    end

    test "create_team/1 with valid data creates a team" do
      assert {:ok, %Team{} = team} = Teams.create_team(@valid_attrs)
      assert team.name == "some team name"
    end

    test "create_team/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Teams.create_team(@invalid_attrs)
    end

    test "update_team/2 with valid data updates the team" do
      team = team_fixture()
      assert {:ok, %Team{} = team} = Teams.update_team(team, @update_attrs)
      assert team.name == "some updated team name"
    end

    test "update_team/2 with invalid data returns error changeset" do
      team = team_fixture()
      assert {:error, %Ecto.Changeset{}} = Teams.update_team(team, @invalid_attrs)
      assert team == Teams.get_team!(team.id)
    end

    test "delete_team/1 deletes the team" do
      team = team_fixture()
      assert {:ok, %Team{}} = Teams.delete_team(team)
      assert_raise Ecto.NoResultsError, fn -> Teams.get_team!(team.id) end
    end

    test "change_team/1 returns a team changeset" do
      team = team_fixture()
      assert %Ecto.Changeset{} = Teams.change_team(team)
    end

    test "add_user_to_team/2 adds a user to a team" do
      team = team_fixture()
      user = user_fixture()
      assert {:ok, updated_team} = Teams.add_user_to_team(user, team)
      assert Enum.any?(updated_team.users, fn u -> u.id == user.id end)
    end

    test "remove_user_from_team/2 removes a user from a team" do
      team = team_fixture()
      user = user_fixture()
      {:ok, team_with_user} = Teams.add_user_to_team(user, team)
      assert {:ok, updated_team} = Teams.remove_user_from_team(user, team_with_user)
      refute Enum.any?(updated_team.users, fn u -> u.id == user.id end)
    end

    test "list_teams_with_users_and_roles/0 returns teams with users and roles" do
      team = team_fixture()
      user = user_fixture()
      {:ok, _} = Teams.add_user_to_team(user, team)
      teams = Teams.list_teams_with_users_and_roles()
      assert length(teams) > 0
      assert hd(teams).users |> length() > 0
      assert hd(hd(teams).users).role != nil
    end
  end
end

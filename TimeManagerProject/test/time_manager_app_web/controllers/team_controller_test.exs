defmodule TimeManagerWeb.TeamControllerTest do
  use TimeManagerWeb.ConnCase

  import TimeManager.TeamsFixtures
  import TimeManager.AccountsFixtures

  alias TimeManager.Teams.Team

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all teams", %{conn: conn} do
      conn = get(conn, ~p"/api/teams")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create team" do
    test "renders team when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/teams", team: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/teams/#{id}")
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "name" => "some name",
        "users" => []
      }
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/teams", team: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update team" do
    setup [:create_team]

    test "renders team when data is valid", %{conn: conn, team: %Team{id: id} = team} do
      conn = put(conn, ~p"/api/teams/#{team.id}", team: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/teams/#{id}")
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "name" => "some updated name",
        "users" => []
      }
    end

    test "renders errors when data is invalid", %{conn: conn, team: team} do
      conn = put(conn, ~p"/api/teams/#{team.id}", team: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete team" do
    setup [:create_team]

    test "deletes chosen team", %{conn: conn, team: team} do
      conn = delete(conn, ~p"/api/teams/#{team.id}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/teams/#{team.id}")
      end
    end
  end

  describe "add user to team" do
    setup [:create_team]

    test "adds user to team successfully", %{conn: conn, team: team} do
      user = user_fixture()
      conn = post(conn, ~p"/api/teams/#{team.id}/users/#{user.id}")
      assert %{"id" => id} = json_response(conn, 200)["data"]
      assert id == team.id
      assert Enum.any?(json_response(conn, 200)["data"]["users"], fn u -> u["id"] == user.id end)
    end
  end

  describe "remove user from team" do
    setup [:create_team_with_user]

    test "removes user from team successfully", %{conn: conn, team: team, user: user} do
      conn = delete(conn, ~p"/api/teams/#{team.id}/users/#{user.id}")
      assert %{"id" => id} = json_response(conn, 200)["data"]
      assert id == team.id
      refute Enum.any?(json_response(conn, 200)["data"]["users"], fn u -> u["id"] == user.id end)
    end
  end

  defp create_team(_) do
    team = team_fixture()
    %{team: team}
  end

  defp create_team_with_user(_) do
    team = team_fixture()
    user = user_fixture()
    {:ok, updated_team} = TimeManager.Teams.add_user_to_team(user, team)
    %{team: updated_team, user: user}
  end
end

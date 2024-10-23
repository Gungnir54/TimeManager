defmodule TimeManagerWeb.ClocksControllerTest do
  use TimeManagerWeb.ConnCase

  import TimeManager.ClockingFixtures
  import TimeManager.AccountsFixtures

  alias TimeManager.Clocking.Clocks

  @create_attrs %{status: true, time: ~N[2023-10-19 10:00:00]}
  @update_attrs %{status: false, time: ~N[2023-10-19 11:00:00]}
  @invalid_attrs %{status: nil, time: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all clocks for a user", %{conn: conn} do
      user = user_fixture()
      clock = clocks_fixture(user_id: user.id)
      conn = get(conn, ~p"/api/clocks/#{user.id}")
      assert json_response(conn, 200) == [
        %{"id" => clock.id, "status" => clock.status, "time" => NaiveDateTime.to_iso8601(clock.time), "user_id" => user.id}
      ]
    end
  end

  describe "create clocks" do
    test "renders clock when data is valid", %{conn: conn} do
      user = user_fixture()
      conn = post(conn, ~p"/api/clocks/#{user.id}", clock: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)

      conn = get(conn, ~p"/api/clocks/#{id}")
      assert json_response(conn, 200) == %{
        "id" => id,
        "status" => true,
        "time" => "2023-10-19T10:00:00",
        "user_id" => user.id
      }
    end

    test "renders errors when data is invalid", %{conn: conn} do
      user = user_fixture()
      conn = post(conn, ~p"/api/clocks/#{user.id}", clock: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update clocks" do
    setup [:create_clocks]

    test "renders clock when data is valid", %{conn: conn, clocks: %Clocks{id: id} = clocks} do
      conn = put(conn, ~p"/api/clocks/#{clocks.id}", clock: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)

      conn = get(conn, ~p"/api/clocks/#{id}")
      assert json_response(conn, 200) == %{
        "id" => id,
        "status" => false,
        "time" => "2023-10-19T11:00:00",
        "user_id" => clocks.user_id
      }
    end

    test "renders errors when data is invalid", %{conn: conn, clocks: clocks} do
      conn = put(conn, ~p"/api/clocks/#{clocks.id}", clock: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete clocks" do
    setup [:create_clocks]

    test "deletes chosen clocks", %{conn: conn, clocks: clocks} do
      conn = delete(conn, ~p"/api/clocks/#{clocks.id}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/clocks/#{clocks.id}")
      end
    end
  end

  defp create_clocks(_) do
    user = user_fixture()
    clocks = clocks_fixture(user_id: user.id)
    %{clocks: clocks}
  end
end

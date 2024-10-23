defmodule TimeManagerWeb.WorkingtimeControllerTest do
  use TimeManagerWeb.ConnCase

  import TimeManager.TimeFixtures
  import TimeManager.AccountsFixtures

  alias TimeManager.Time.Workingtime

  @create_attrs %{start: ~N[2023-10-19 10:00:00], end: ~N[2023-10-19 18:00:00]}
  @update_attrs %{start: ~N[2023-10-19 09:00:00], end: ~N[2023-10-19 17:00:00]}
  @invalid_attrs %{start: nil, end: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all workingtimes for a user within a date range", %{conn: conn} do
      user = user_fixture()
      workingtime = workingtime_fixture(user_id: user.id)
      conn = get(conn, ~p"/api/workingtimes/#{user.id}?start=2023-10-18&end=2023-10-20")
      assert [returned_workingtime] = json_response(conn, 200)
      assert returned_workingtime["id"] == workingtime.id
    end
  end

  describe "create workingtime" do
    test "renders workingtime when data is valid", %{conn: conn} do
      user = user_fixture()
      conn = post(conn, ~p"/api/workingtimes/#{user.id}", time: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)

      conn = get(conn, ~p"/api/workingtimes/#{user.id}/#{id}")
      assert json_response(conn, 200) == %{
        "id" => id,
        "start" => "2023-10-19T10:00:00",
        "end" => "2023-10-19T18:00:00",
        "user_id" => user.id
      }
    end

    test "renders errors when data is invalid", %{conn: conn} do
      user = user_fixture()
      conn = post(conn, ~p"/api/workingtimes/#{user.id}", time: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update workingtime" do
    setup [:create_workingtime]

    test "renders workingtime when data is valid", %{conn: conn, workingtime: %Workingtime{id: id} = workingtime} do
      conn = put(conn, ~p"/api/workingtimes/#{workingtime.id}", time: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)

      conn = get(conn, ~p"/api/workingtimes/#{workingtime.user_id}/#{id}")
      assert json_response(conn, 200) == %{
        "id" => id,
        "start" => "2023-10-19T09:00:00",
        "end" => "2023-10-19T17:00:00",
        "user_id" => workingtime.user_id
      }
    end

    test "renders errors when data is invalid", %{conn: conn, workingtime: workingtime} do
      conn = put(conn, ~p"/api/workingtimes/#{workingtime.id}", time: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete workingtime" do
    setup [:create_workingtime]

    test "deletes chosen workingtime", %{conn: conn, workingtime: workingtime} do
      conn = delete(conn, ~p"/api/workingtimes/#{workingtime.id}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/workingtimes/#{workingtime.user_id}/#{workingtime.id}")
      end
    end
  end

  defp create_workingtime(_) do
    user = user_fixture()
    workingtime = workingtime_fixture(user_id: user.id)
    %{workingtime: workingtime}
  end
end

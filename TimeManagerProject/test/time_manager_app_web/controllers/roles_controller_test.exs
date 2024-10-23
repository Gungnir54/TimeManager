defmodule TimeManagerWeb.RolesControllerTest do
  use TimeManagerWeb.ConnCase

  import TimeManager.RightsFixtures
  import TimeManager.AccountsFixtures

  alias TimeManager.Rights.Roles

  @create_attrs %{rolename: "some rolename"}
  @update_attrs %{rolename: "some updated rolename"}
  @invalid_attrs %{rolename: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all roles", %{conn: conn} do
      conn = get(conn, ~p"/api/roles")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create roles" do
    test "renders role when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/roles", @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)

      conn = get(conn, ~p"/api/roles/#{id}")
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "rolename" => "some rolename"
      }
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/roles", roles: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update roles" do
    setup [:create_roles]

    test "renders role when data is valid", %{conn: conn, roles: %Roles{id: id} = roles} do
      conn = put(conn, ~p"/api/roles/#{roles.id}", @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/roles/#{id}")
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "rolename" => "some updated rolename"
      }
    end

    test "renders errors when data is invalid", %{conn: conn, roles: roles} do
      conn = put(conn, ~p"/api/roles/#{roles.id}", @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete roles" do
    setup [:create_roles]

    test "deletes chosen roles", %{conn: conn, roles: roles} do
      conn = delete(conn, ~p"/api/roles/#{roles.id}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/roles/#{roles.id}")
      end
    end
  end

  describe "update user role" do
    test "updates user role successfully", %{conn: conn} do
      user = user_fixture()
      role = roles_fixture()
      conn = put(conn, ~p"/api/roles/users/#{user.id}/#{role.id}")
      assert %{"id" => id} = json_response(conn, 200)["data"]
      assert id == user.id
      assert json_response(conn, 200)["data"]["role"]["id"] == role.id
    end
  end

  defp create_roles(_) do
    roles = roles_fixture()
    %{roles: roles}
  end
end

defmodule TimeManagerWeb.UserControllerTest do
  use TimeManagerWeb.ConnCase

  import TimeManager.AccountsFixtures

  alias TimeManager.Accounts.User

  @create_attrs %{email: "test@example.com", username: "testuser", password: "password123"}
  @update_attrs %{email: "updated@example.com", username: "updateduser"}
  @invalid_attrs %{email: nil, username: nil, password: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, ~p"/api/users")
      assert json_response(conn, 200)["data"] != []
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", @create_attrs)
      assert %{"id" => id, "token" => token} = json_response(conn, 201)
      assert String.length(token) > 0

      conn = get(conn, ~p"/api/users/#{id}")
      assert json_response(conn, 200)["data"]["id"] == id
      assert json_response(conn, 200)["data"]["email"] == "test@example.com"
      assert json_response(conn, 200)["data"]["username"] == "testuser"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put(conn, ~p"/api/users/#{user.id}", user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/users/#{id}")
      assert json_response(conn, 200)["data"]["id"] == id
      assert json_response(conn, 200)["data"]["email"] == "updated@example.com"
      assert json_response(conn, 200)["data"]["username"] == "updateduser"
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, ~p"/api/users/#{user.id}", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, ~p"/api/users/#{user.id}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/users/#{user.id}")
      end
    end
  end

  describe "login" do
    setup [:create_user]

    test "renders user and token when credentials are valid", %{conn: conn} do
      conn = post(conn, ~p"/api/login", %{email: "test@example.com", password: "password123"})
      assert %{"message" => "Login successful", "token" => token} = json_response(conn, 200)
      assert String.length(token) > 0
    end

    test "renders errors when credentials are invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/login", %{email: "test@example.com", password: "wrongpassword"})
      assert json_response(conn, 401)["error"] == "Invalid email or password"
    end
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end
end

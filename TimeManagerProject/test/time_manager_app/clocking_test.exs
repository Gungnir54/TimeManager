defmodule TimeManager.ClockingTest do
  use TimeManager.DataCase

  alias TimeManager.Clocking
  alias TimeManager.Clocking.Clocks

  import TimeManager.ClockingFixtures
  import TimeManager.AccountsFixtures

  describe "clock" do
    @valid_attrs %{status: true, time: ~N[2023-01-01 12:00:00]}
    @update_attrs %{status: false, time: ~N[2023-01-02 12:00:00]}
    @invalid_attrs %{status: nil, time: nil}

    test "list_clock/0 returns all clocks" do
      clocks = clocks_fixture()
      assert Clocking.list_clock() == [clocks]
    end

    test "get_clocks!/1 returns the clocks with given id" do
      clocks = clocks_fixture()
      assert Clocking.get_clocks!(clocks.id) == clocks
    end

    test "create_clocks/1 with valid data creates a clocks" do
      assert {:ok, %Clocks{} = clocks} = Clocking.create_clocks(@valid_attrs)
      assert clocks.status == true
      assert clocks.time == ~N[2023-01-01 12:00:00]
    end

    test "create_clocks/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Clocking.create_clocks(@invalid_attrs)
    end

    test "update_clocks/2 with valid data updates the clocks" do
      clocks = clocks_fixture()
      assert {:ok, %Clocks{} = clocks} = Clocking.update_clocks(clocks, @update_attrs)
      assert clocks.status == false
      assert clocks.time == ~N[2023-01-02 12:00:00]
    end

    test "update_clocks/2 with invalid data returns error changeset" do
      clocks = clocks_fixture()
      assert {:error, %Ecto.Changeset{}} = Clocking.update_clocks(clocks, @invalid_attrs)
      assert clocks == Clocking.get_clocks!(clocks.id)
    end

    test "delete_clocks/1 deletes the clocks" do
      clocks = clocks_fixture()
      assert {:ok, %Clocks{}} = Clocking.delete_clocks(clocks)
      assert_raise Ecto.NoResultsError, fn -> Clocking.get_clocks!(clocks.id) end
    end

    test "change_clocks/1 returns a clocks changeset" do
      clocks = clocks_fixture()
      assert %Ecto.Changeset{} = Clocking.change_clocks(clocks)
    end

    test "list_clocks_for_user/1 returns clocks for a specific user" do
      user = user_fixture()
      clocks1 = clocks_fixture(%{user_id: user.id})
      clocks2 = clocks_fixture(%{user_id: user.id})
      _other_user_clocks = clocks_fixture()

      user_clocks = Clocking.list_clocks_for_user(user.id)
      assert length(user_clocks) == 2
      assert Enum.all?(user_clocks, fn c -> c.id in [clocks1.id, clocks2.id] end)
    end
  end
end

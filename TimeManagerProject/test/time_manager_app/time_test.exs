defmodule TimeManager.TimeTest do
  use TimeManager.DataCase

  alias TimeManager.Time
  alias TimeManager.Time.Workingtime

  describe "workingtimes" do
    import TimeManager.TimeFixtures

    test "list_workingtimes/0 returns all workingtimes" do
      workingtime = workingtime_fixture()
      assert Time.list_workingtimes() == [workingtime]
    end

    test "get_workingtime!/1 returns the workingtime with given id" do
      workingtime = workingtime_fixture()
      assert Time.get_workingtime!(workingtime.id) == workingtime
    end

    test "create_workingtime/1 with valid data creates a workingtime" do
      valid_attrs = %{start: ~N[2023-10-19 10:00:00], end: ~N[2023-10-19 18:00:00], user_id: 1}
      assert {:ok, %Workingtime{} = workingtime} = Time.create_workingtime(valid_attrs)
      assert workingtime.start == ~N[2023-10-19 10:00:00]
      assert workingtime.end == ~N[2023-10-19 18:00:00]
    end

    test "create_workingtime/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Time.create_workingtime(%{start: nil, end: nil})
    end

    test "update_workingtime/2 with valid data updates the workingtime" do
      workingtime = workingtime_fixture()
      update_attrs = %{start: ~N[2023-10-20 09:00:00], end: ~N[2023-10-20 17:00:00]}
      assert {:ok, %Workingtime{} = updated_workingtime} = Time.update_workingtime(workingtime, update_attrs)
      assert updated_workingtime.start == ~N[2023-10-20 09:00:00]
      assert updated_workingtime.end == ~N[2023-10-20 17:00:00]
    end

    test "delete_workingtime/1 deletes the workingtime" do
      workingtime = workingtime_fixture()
      assert {:ok, %Workingtime{}} = Time.delete_workingtime(workingtime)
      assert_raise Ecto.NoResultsError, fn -> Time.get_workingtime!(workingtime.id) end
    end

    test "list_workingtimes_by_user_and_date/3 returns workingtimes for a specific user and date range" do
      user = TimeManager.AccountsFixtures.user_fixture()
      workingtime1 = workingtime_fixture(%{user_id: user.id, start: ~N[2023-10-19 10:00:00], end: ~N[2023-10-19 18:00:00]})
      workingtime2 = workingtime_fixture(%{user_id: user.id, start: ~N[2023-10-20 09:00:00], end: ~N[2023-10-20 17:00:00]})
      _workingtime3 = workingtime_fixture(%{user_id: user.id, start: ~N[2023-10-21 10:00:00], end: ~N[2023-10-21 18:00:00]})

      result = Time.list_workingtimes_by_user_and_date(user.id, ~N[2023-10-19 00:00:00], ~N[2023-10-20 23:59:59])
      assert length(result) == 2
      assert Enum.member?(result, workingtime1)
      assert Enum.member?(result, workingtime2)
    end
  end
end

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(TimeManager.Repo, :manual)

Code.require_file("test/support/fixtures/accounts_fixtures.ex")
Code.require_file("test/support/fixtures/teams_fixtures.ex")
Code.require_file("test/support/fixtures/clocking_fixtures.ex")
Code.require_file("test/support/fixtures/time_fixtures.ex")

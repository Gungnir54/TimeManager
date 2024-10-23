alias TimeManager.Repo
alias TimeManager.Rights.Roles
alias TimeManager.Accounts
alias TimeManager.Teams
alias TimeManager.Clocking.Clocks
alias TimeManager.Time.Workingtime

Ecto.Adapters.SQL.query(TimeManager.Repo, "TRUNCATE TABLE clock RESTART IDENTITY;")
Ecto.Adapters.SQL.query(TimeManager.Repo, "TRUNCATE TABLE workingtimes RESTART IDENTITY;")
Ecto.Adapters.SQL.query(TimeManager.Repo, "TRUNCATE TABLE users RESTART IDENTITY CASCADE;")
Ecto.Adapters.SQL.query(TimeManager.Repo, "TRUNCATE TABLE roles RESTART IDENTITY CASCADE;")
Ecto.Adapters.SQL.query(TimeManager.Repo, "TRUNCATE TABLE teams RESTART IDENTITY CASCADE;")

employee_role = Repo.insert!(%Roles{rolename: "employee"})
manager_role = Repo.insert!(%Roles{rolename: "manager"})
general_manager_role = Repo.insert!(%Roles{rolename: "general_manager"})

# Insert teams
team_alpha = Repo.insert!(%Teams.Team{name: "Team Alpha"})
team_beta = Repo.insert!(%Teams.Team{name: "Team Beta"})

john_attrs = %{
  username: "johndoe",
  email: "john.doe@example.com",
  password: "azerty",
  role_id: "1"
}

mary_attrs = %{
  username: "marysmith",
  email: "mary.smith@example.com",
  password: "azerty",
  role_id: "1"
}

paul_attrs = %{
  username: "paulbrown",
  email: "paul.brown@example.com",
  password: "azerty",
  role_id: "1"
}

john = Accounts.create_user(john_attrs)
mary = Accounts.create_user(mary_attrs)
paul = Accounts.create_user(paul_attrs)

Teams.add_user_to_team(john, team_alpha)
Teams.add_user_to_team(mary, team_alpha)
Teams.add_user_to_team(paul, team_beta)

# John Doe's working times for the week
john_times = [
  {~N[2024-10-14 08:00:00], ~N[2024-10-14 15:00:00]},  # Monday
  {~N[2024-10-15 08:15:00], ~N[2024-10-15 15:15:00]},  # Tuesday
  {~N[2024-10-16 08:30:00], ~N[2024-10-16 15:30:00]},  # Wednesday
  {~N[2024-10-17 08:00:00], ~N[2024-10-17 15:00:00]},  # Thursday
  {~N[2024-10-18 08:45:00], ~N[2024-10-18 15:45:00]}   # Friday
]

# Mary Smith's working times for the week
mary_times = [
  {~N[2024-10-14 09:30:00], ~N[2024-10-14 16:30:00]},  # Monday
  {~N[2024-10-15 09:45:00], ~N[2024-10-15 16:45:00]},  # Tuesday
  {~N[2024-10-16 09:00:00], ~N[2024-10-16 16:00:00]},  # Wednesday
  {~N[2024-10-17 09:30:00], ~N[2024-10-17 16:30:00]},  # Thursday
  {~N[2024-10-18 10:00:00], ~N[2024-10-18 17:00:00]}   # Friday
]

# Paul Brown's working times for the week
paul_times = [
  {~N[2024-10-14 07:45:00], ~N[2024-10-14 13:45:00]},  # Monday
  {~N[2024-10-15 08:00:00], ~N[2024-10-15 14:00:00]},  # Tuesday
  {~N[2024-10-16 07:30:00], ~N[2024-10-16 13:30:00]},  # Wednesday
  {~N[2024-10-17 07:45:00], ~N[2024-10-17 13:45:00]},  # Thursday
  {~N[2024-10-18 08:15:00], ~N[2024-10-18 14:15:00]}   # Friday
]

# Insert clocks and working times for each person
# John Doe
Enum.each(john_times, fn {clock_in_time, clock_out_time} ->
  Repo.insert!(%Clocks{
    status: true,  # Clocked in
    time: clock_in_time,
    user_id: john.id
  })

  Repo.insert!(%Clocks{
    status: false,  # Clocked out
    time: clock_out_time,
    user_id: john.id
  })

  Repo.insert!(%Workingtime{
    start: clock_in_time,
    end: clock_out_time,
    user_id: john.id
  })
end)

# Mary Smith
Enum.each(mary_times, fn {clock_in_time, clock_out_time} ->
  Repo.insert!(%Clocks{
    status: true,  # Clocked in
    time: clock_in_time,
    user_id: mary.id
  })

  Repo.insert!(%Clocks{
    status: false,  # Clocked out
    time: clock_out_time,
    user_id: mary.id
  })

  Repo.insert!(%Workingtime{
    start: clock_in_time,
    end: clock_out_time,
    user_id: mary.id
  })
end)

# Paul Brown
Enum.each(paul_times, fn {clock_in_time, clock_out_time} ->
  Repo.insert!(%Clocks{
    status: true,  # Clocked in
    time: clock_in_time,
    user_id: paul.id
  })

  Repo.insert!(%Clocks{
    status: false,  # Clocked out
    time: clock_out_time,
    user_id: paul.id
  })

  Repo.insert!(%Workingtime{
    start: clock_in_time,
    end: clock_out_time,
    user_id: paul.id
  })
end)

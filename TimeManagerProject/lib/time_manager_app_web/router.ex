defmodule TimeManagerWeb.Router do
  use TimeManagerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug TimeManagerWeb.Plugs.VerifyJWT
  end

  scope "/api", TimeManagerWeb do
    pipe_through :api

    post "/register", UserController, :create # create a user
    post "/login", UserController, :login # login a user

    scope "/roles" do
      get "/", RolesController, :index # get all users basics datas
      post "/", RolesController, :create # create a user
      get "/:id", RolesController, :show # get all user datas
      put "/:id", RolesController, :update # change rolename
      post "/update_user_role", RolesController, :update_user_role # change user role (promote or demote)
      delete "/:id", RolesController, :delete # delete a role
    end

    scope "/users" do
      get "/", UserController, :index
      get "/with_clocks", UserController, :index_with_clocks
      get "/with_clocks_and_workingtimes", UserController, :index_with_clocks_and_workingtimes
      get "/:id", UserController, :show
      get "/:id/with_clocks", UserController, :show_with_clocks
      get "/:id/with_clocks_and_workingtimes", UserController, :show_with_clocks_and_workingtimes
      post "/", UserController, :create
      put "/:id", UserController, :update
      delete "/:id", UserController, :delete
    end

    scope "/workingtime" do
      get "/:user_id", WorkingtimeController, :index # get all user's workingtimes between start & end date in params
      get "/:user_id/:id", WorkingtimeController, :show # get one user's workingtime
      post "/:user_id", WorkingtimeController, :create # create a workingtime for a user
      put "/:id", WorkingtimeController, :update # change start and/or end field(s) by workingtime id
      delete "/:id", WorkingtimeController, :delete # delete a workingtime
    end

    scope "/clocks" do
      get "/:user_id", ClocksController, :index # get all user's clocks
      post "/:user_id", ClocksController, :create # create one clock for a user
      put "/:clock_id", ClocksController, :update # change clock date and/or status
      delete "/:clock_id", ClocksController, :delete # delete a clock
    end

    resources "/teams", TeamController, except: [:new, :edit] do
      post "/add_user/:user_id", TeamController, :add_user_to_team, as: :add_user_to_team # add a user to a team
      delete "/remove_users/:user_id", TeamController, :remove_user_from_team # remove a user from a team
    end
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:time_manager_app, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: TimeManagerWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end

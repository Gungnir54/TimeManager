import Config

# Configure your database
config :time_manager_app, TimeManager.Repo,
       username: System.get_env("POSTGRES_USER") || "admin",
       password: System.get_env("POSTGRES_PASSWORD") || "admin",
       hostname: System.get_env("POSTGRES_HOST") || "localhost",
       database: System.get_env("POSTGRES_DB") || "time_manager_app_dev",
       port: String.to_integer(System.get_env("POSTGRES_PORT") || "5432"),
       stacktrace: true,
       show_sensitive_data_on_connection_error: true,
       pool_size: 10

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we can use it
# to bundle .js and .css sources.
config :time_manager_app, TimeManagerWeb.Endpoint,
       # Lier à 0.0.0.0 pour permettre l'accès depuis Docker
       http: [ip: {0, 0, 0, 0}, port: String.to_integer(System.get_env("ELIXIR_PORT") || "4000")],
       check_origin: false,
       code_reloader: true,
       debug_errors: true,
       secret_key_base: System.get_env("ELIXIR_SECRET_KEY_BASE") || "HXPzXIIADQyg6cA57RDS8i75N18lCZaQhix8vl7WWIoq0TD5f7IkSJsTuLl8t8PT",
       watchers: [
         esbuild: {Esbuild, :install_and_run, [:time_manager_app, ~w(--sourcemap=inline --watch)]},
         tailwind: {Tailwind, :install_and_run, [:time_manager_app, ~w(--watch)]}
       ]

# ## SSL Support
#
# In order to use HTTPS in development, a self-signed
# certificate can be generated by running the following
# Mix task:
#
#     mix phx.gen.cert
#
# Run `mix help phx.gen.cert` for more information.
#
# The `http:` config above can be replaced with:
#
#     https: [
#       port: 4001,
#       cipher_suite: :strong,
#       keyfile: "priv/cert/selfsigned_key.pem",
#       certfile: "priv/cert/selfsigned.pem"
#     ],
#
# If desired, both `http:` and `https:` keys can be
# configured to run both http and https servers on
# different ports.

# Enable dev routes for dashboard and mailbox
config :time_manager_app, dev_routes: true

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

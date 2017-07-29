# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :trainline_lunch, TrainlineLunchWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "BOi8/xBU0n/U3D4+XKwlxzud2eehixKF4fywYc+myQr61Xq4gu0z3FmTzVbJz4Mn",
  render_errors: [view: TrainlineLunchWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: TrainlineLunch.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

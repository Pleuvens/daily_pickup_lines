import Config

# Note we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the `mix assets.deploy` task,
# which you should run after static files are built and
# before starting your production server.
config :daily_pickup_line, DailyPickupLineWeb.Endpoint,
  url: [host: "dailypickuplines.pleuvens.com", scheme: "https", port: 443],
  cache_static_manifest: "priv/static/cache_manifest.json",
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: DailyPickupLineWeb.ErrorHTML, json: DailyPickupLineWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: DailyPickupLine.PubSub,
  live_view: [signing_salt: "afpgdRQW"]

# Configures Swoosh API Client
config :swoosh, api_client: Swoosh.ApiClient.Finch, finch_name: DailyPickupLine.Finch

# Disable Swoosh Local Memory Storage
config :swoosh, local: false

# Do not print debug messages in production
config :logger, level: :info

# Runtime production configuration, including reading
# of environment variables, is done on config/runtime.exs.

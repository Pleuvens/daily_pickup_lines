defmodule DailyPickupLine.Repo do
  use Ecto.Repo,
    otp_app: :daily_pickup_line,
    adapter: Ecto.Adapters.Postgres
end

defmodule DailyPickupLine.PickupLine do
  use Ecto.Schema

  import Ecto.Query

  alias __MODULE__
  alias DailyPickupLine.Repo

  schema "pickup_lines" do
    field :content, :map
    field :status, Ecto.Enum, values: [:to_display, :currently_displayed, :already_displayed], default: :to_display
    field :displayed_at, :utc_datetime

    timestamps()
  end

  def get_currently_displayed_pickup_line() do
    Repo.one(from(pickup_line in PickupLine, where: pickup_line.status == :currently_displayed))
  end

  def get_pickup_line_content(nil, _locale), do: "Forgive me, for I have no clever lines to offer… Your beauty has stolen the breath from my soul."

  def get_pickup_line_content(%PickupLine{content: content}, locale) do
    content[locale]
  end
end

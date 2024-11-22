defmodule DailyPickupLineWeb.HomeLive do

  use DailyPickupLineWeb, :live_view

  alias DailyPickupLine.PickupLine

  @impl true
  def mount(_params, _session, socket) do
    content =
      PickupLine.get_currently_displayed_pickup_line()
      |> PickupLine.get_pickup_line_content("en")

    {:ok, socket |> assign(pickup_line: content)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.pickup_line pickup_line={@pickup_line} />
    """
  end
end

defmodule DailyPickupLineWeb.AdminPickupLinesLive do
  @moduledoc false

  use Backpex.LiveResource,
    adapter_config: [
      schema: DailyPickupLine.PickupLine,
      repo: DailyPickupLine.Repo,
      update_changeset: &DailyPickupLine.PickupLine.update_changeset/3,
      create_changeset: &DailyPickupLine.PickupLine.create_changeset/3,
      item_query: &__MODULE__.item_query/3
    ],
    layout: {DailyPickupLineWeb.Layouts, :admin},
    pubsub: [
      name: DailyPickupLine.PubSub,
      topic: "pickup_lines",
      event_prefix: "pickup_line_"
    ]

  @impl Backpex.LiveResource
  def singular_name, do: "Pickup line"

  @impl Backpex.LiveResource
  def plural_name, do: "Pickup lines"

  @impl Backpex.LiveResource
  def fields do
    [
      content: %{
        module: Backpex.Fields.InlineCRUD,
        label: "Content",
        type: :embed,
        except: [:index],
        child_fields: [
          language: %{
            module: Backpex.Fields.Text,
            label: "Language"
          },
          text: %{
            module: Backpex.Fields.Text,
            label: "Text"
          }
        ]
      },
      status: %{
        module: Backpex.Fields.Text,
        label: "Status"
      },
      displayed_at: %{
        module: Backpex.Fields.DateTime,
        label: "Content"
      },
    ]
  end
end

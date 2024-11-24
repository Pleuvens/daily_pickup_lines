defmodule DailyPickupLine.PickupLine do
  use Ecto.Schema

  import Ecto.Query
  import Ecto.Changeset

  alias __MODULE__
  alias DailyPickupLine.Repo

  @cast_fields ~w[status]a
  @required_fields ~w[status]a

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "pickup_lines" do
    field :status, Ecto.Enum, values: [:to_display, :currently_displayed, :already_displayed], default: :to_display
    field :displayed_at, :utc_datetime

    embeds_many :content, Content do
      field :language, :string
      field :text, :string
    end

    timestamps()
  end

  def create_changeset(pickup_line, attrs, _metadatas \\ []) do
    pickup_line
    |> cast(attrs, @cast_fields)
    |> cast_embed(:content, with: &content_changeset/2, sort_param: :content_order, drop_param: :content_delete)
    |> validate_required(@required_fields)
  end

  def update_changeset(pickup_line, attrs, _metadatas \\ []) do
    pickup_line
    |> cast(attrs, @cast_fields)
    |> cast_embed(:content, with: &content_changeset/2, sort_param: :content_order, drop_param: :content_delete)
    |> validate_required(@required_fields)
  end

  def get_currently_displayed_pickup_line() do
    Repo.one(from(pickup_line in PickupLine, where: pickup_line.status == :currently_displayed))
  end

  def get_pickup_line_content(nil, _locale), do: "Forgive me, for I have no clever lines to offer… Your beauty has stolen the breath from my soul."

  def get_pickup_line_content(%PickupLine{content: content}, locale) do
    case Enum.find(content,  fn %{language: language} -> language == locale end ) do
      %{text: text} -> text
      _ -> get_pickup_line_content(nil, locale)
    end
  end

  defp content_changeset(content, attrs) do
    content
    |> cast(attrs, [:language, :text])
    |> validate_required([:language, :text])
  end
end

defmodule DailyPickupLine.Repo.Migrations.AddPickupLineTable do
  use Ecto.Migration

  def up do
    create table(:pickup_lines, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :content, :jsonb, null: false
      add :status, :string, null: false
      add :displayed_at, :utc_datetime, null: true

      timestamps()
    end
  end

  def down do
    drop table(:pickup_lines)
  end
end

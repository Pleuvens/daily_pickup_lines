defmodule DailyPickupLine.Utils do
  import Ecto.Query

  alias DailyPickupLine.PickupLine
  alias DailyPickupLine.Repo

  @pickup_lines_file_path "pickup_lines.json"
  def import_pickup_lines() do
    lines =
    :code.priv_dir(:daily_pickup_line)
    |> Path.join(@pickup_lines_file_path)
    |> File.read!()
    |> Jason.decode!()
    |> Enum.map(fn content ->
      %{content: content, status: :to_display}
    end)

    Repo.insert_all(PickupLine, lines)
  end

  def reset_pickup_lines_status() do
    Repo.update_all(
      from(p in PickupLine,
        where: p.status == :already_displayed,
        where: fragment("? < now() - INTERVAL '1 year'", p.displayed_at)
      ),
      set: [status: :to_display]
    )
  end
end

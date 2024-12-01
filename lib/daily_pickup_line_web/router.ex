defmodule DailyPickupLineWeb.Router do
  use DailyPickupLineWeb, :router

  import Backpex.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {DailyPickupLineWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DailyPickupLineWeb do
    pipe_through :browser

    live "/", HomeLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", DailyPickupLineWeb do
  #   pipe_through :api
  # end

  scope "/admin", DailyPickupLineWeb do
    pipe_through [:browser, :admin_basic_auth]

    backpex_routes()

    live_session :default, on_mount: Backpex.InitAssigns do
      live_resources("/pickup_lines", AdminPickupLinesLive)
    end
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:daily_pickup_line, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: DailyPickupLineWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  defp admin_basic_auth(conn, _opts) do
    username = "admin"
    password = Application.get_env(:daily_pickup_line, :admin_basic_auth_password)

    Plug.BasicAuth.basic_auth(conn, username: username, password: password)

    with {user, pass} <- Plug.BasicAuth.parse_basic_auth(conn),
         true <- Plug.Crypto.secure_compare(username, user),
         true <- Plug.Crypto.secure_compare(password, pass) do
      Plug.Conn.assign(conn, :admin_user?, true)
    else
      _ -> conn |> Plug.BasicAuth.request_basic_auth() |> halt()
    end
  end
end

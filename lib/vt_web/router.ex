defmodule VtWeb.Router do
  use VtWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {VtWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", VtWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  scope "/api", VtWeb do
    pipe_through :api

    scope "/transport" do
      # get "/fare", TransportController, :estimate_fare
      # get "/timetable", TimetableController, :get

      # Train
      scope "/metro" do
      end

      # Bus
      scope "/ptv" do
      end
    end
  end

  # Enable LiveDashboard in development
  if Application.compile_env(:vt, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: VtWeb.Telemetry
    end
  end
end

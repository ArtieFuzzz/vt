defmodule VtWeb.PageController do
  use VtWeb, :controller

  def home(conn, _params) do
    IO.puts(inspect(Vt.Timetable.route_types()))
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end
end

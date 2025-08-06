defmodule VtWeb.PageController do
  use VtWeb, :controller

  def home(conn, _params) do
    IO.puts(inspect(Vt.Timetable.health_check()))
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end
end

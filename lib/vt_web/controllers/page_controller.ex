defmodule VtWeb.PageController do
  use VtWeb, :controller

  def home(conn, params) do
    %{"routes" => routes} = Vt.Timetable.search_route(params["search"], params["type"])

    render(conn, :home, layout: false, routes: routes)
  end
end

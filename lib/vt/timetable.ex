defmodule Vt.Timetable do
  @moduledoc false
  use GenServer

  @base_url "https://timetableapi.ptv.vic.gov.au/v3"

  def start_link(_init) do
    GenServer.start_link(
      __MODULE__,
      {Application.get_env(:vt, :ptv_dev_id), Application.get_env(:vt, :ptv_api_key)},
      name: __MODULE__
    )
  end

  @impl true
  def init(init_arg) do
    {:ok, init_arg}
  end

  defp request!(path, query, _state = {dev_id, api_key}) do
    request_query = URI.encode_query(query ++ [devid: dev_id])

    uri =
      URI.parse(@base_url)
      |> URI.append_path(path)
      |> URI.append_query(request_query)

    signature = :crypto.mac(:hmac, :sha, api_key, "#{uri.path}?#{uri.query}") |> Base.encode16()

    uri = uri |> URI.append_query(URI.encode_query(signature: signature))

    req =
      Req.new(
        url: uri,
        headers: [accept: "application/json"]
      )

    Req.get!(req)
  end

  @impl true
  def handle_call({:request, route, query}, _from, state) do
    request = request!(route, query, state)

    if request.status == 200 do
      {:reply, request.body, state}
    else
      {:reply, {:error, request.body}, state}
    end
  end

  # Helper functions
  # - More high-level
  def route_types, do: GenServer.call(__MODULE__, {:request, "/route_types", []})

  def search_route(name, type \\ 2),
    do: GenServer.call(__MODULE__, {:request, "/routes", [route_name: name, route_types: type]})
end

defmodule Vt.Timetable do
  @moduledoc false
  use GenServer

  @base_url "https://timetableapi.ptv.vic.gov.au/v3"

  def start_link(_init, _opts) do
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

  # Write a request/3 function
  defp request!(path, params, _state = {dev_id, api_key}) do
    uri =
      URI.parse(@base_url)
      |> URI.append_path(path)
      |> URI.append_query(URI.encode_query(params))

    signature = :crypto.mac(:sha, api_key, "#{uri.path}?#{uri.query}") |> Base.encode16()

    req =
      Req.new(
        url: uri,
        headers: [accept: "application/json"],
        params: params ++ [devid: dev_id, signature: signature]
      )

    Req.run!(req)
  end

  @impl true
  def handle_call(:healthcheck, _from, state) do
    response = request!("/healthcheck", [], state)

    {:reply, response, state}
  end
end

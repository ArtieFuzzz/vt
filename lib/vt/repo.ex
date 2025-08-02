defmodule Vt.Repo do
  use Ecto.Repo,
    otp_app: :vt,
    adapter: Ecto.Adapters.Postgres
end

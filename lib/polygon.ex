defmodule Polygon do
  require Logger

  @type(timespan() :: :minute, :hour, :day, :week, :month, :quarter, :year)
  @type(sort() :: :asc, :desc)

  def client do
    case Application.fetch_env(:polygon, :key) do
      {:ok, key} ->
        client(key)

      :error ->
        {:error, :no_polygon_key}
    end
  end

  def client(polygon_key) do
    middleware = [
      {Tesla.Middleware.BaseUrl, "https://api.polygon.io/"},
      {Tesla.Middleware.Headers, [{"Authorization", "Bearer #{polygon_key}"}]},
      Tesla.Middleware.JSON
    ]

    adapter = {Tesla.Adapter.Finch, name: Finch}

    Tesla.client(middleware, adapter)
  end

  defdelegate quotes(client, request), to: Polygon.Quotes, as: :request
  defdelegate trades(client, request), to: Polygon.Trades, as: :request
  defdelegate aggregates(client, request), to: Polygon.Aggregates, as: :request
  defdelegate daily_open_close(client, request), to: Polygon.DailyOpenClose, as: :request
end

defmodule Polygon do
  require Logger

  def client do
    case Application.fetch_env(:polygon, :key) do
      {:ok, key} ->
        middleware = [
          {Tesla.Middleware.BaseUrl, "https://api.polygon.io/"},
          {Tesla.Middleware.Headers, [{"Authorization", "Bearer #{key}"}]},
          Tesla.Middleware.JSON,
          PolygonRateLimit
        ]

        Tesla.client(middleware)

      :error ->
        {:error, :no_polygon_key}
    end
  end
end

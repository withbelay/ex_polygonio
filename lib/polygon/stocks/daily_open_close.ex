defmodule Polygon.Stocks.DailyOpenClose do
  alias Polygon.Stocks.DailyOpenClose.Request
  # https://polygon.io/docs/stocks/get_v1_open-close__stocksticker___date

  @spec request(Tesla.Client.t(), Request.t() | map()) :: {:error, any} | {:ok, map()}
  def request(client, %Request{} = req) do
    with {:ok, result} <- Tesla.get(client, Request.to_url(req)) do
      {:ok, result.body}
      # Response.build(result.body)
    end
  end

  def request(client, params) when is_map(params) do
    case Request.build(params) do
      {:ok, req} -> request(client, req)
      {:error, changeset} -> {:error, changeset}
    end
  end
end

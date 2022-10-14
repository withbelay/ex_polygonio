defmodule Polygon.Aggregates do
  alias Polygon.AggregatesRequest

  # https://polygon.io/docs/stocks/get_v2_aggs_ticker__stocksticker__range__multiplier___timespan___from___to
  @spec request(Tesla.Client.t(), AggregatesRequest.t() | map()) :: {:error, any} | {:ok, map()}
  def request(client, %AggregatesRequest{} = req) do
    with {:ok, result} <- Tesla.get(client, AggregatesRequest.to_url(req)) do
      {:ok, result.body}
    end
  end

  def request(client, params) when is_map(params) do
    case AggregatesRequest.build(params) do
      {:ok, req} -> request(client, req)
      {:error, changeset} -> {:error, changeset}
    end
  end
end

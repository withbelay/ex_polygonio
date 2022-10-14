defmodule Polygon.Quotes do
  alias Polygon.QuotesRequest

  # https://polygon.io/docs/stocks/get_v2_aggs_ticker__stocksticker__range__multiplier___timespan___from___to
  @spec request(Tesla.Client.t(), QuotesRequest.t() | map()) :: {:error, any} | {:ok, map()}
  def request(client, %QuotesRequest{} = req) do
    with {:ok, result} <- Tesla.get(client, QuotesRequest.to_url(req)) do
      {:ok, result.body}
    end
  end

  def request(client, params) when is_map(params) do
    case QuotesRequest.build(params) do
      {:ok, req} -> request(client, req)
      {:error, changeset} -> {:error, changeset}
    end
  end
end

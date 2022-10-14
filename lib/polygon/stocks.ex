defmodule Polygon.Stocks do
  alias Polygon.Stocks.{AggregatesRequest, AggregatesResponse}

  # https://polygon.io/docs/stocks/get_v2_aggs_ticker__stocksticker__range__multiplier___timespan___from___to
  @spec request(binary | Tesla.Client.t(), %AggregatesRequest{})
        }) :: {:error, any} | {:ok, %AggregatesResponse{}}
  def request(client, %AggregatesRequest{} = req) do
    case Tesla.get(client, AggregatesRequest.to_url(req)) do
      {:ok, result} -> AggregatesResponse.build(result.body)
      {:error, reason} -> {:error, reason}
    end
  end
end

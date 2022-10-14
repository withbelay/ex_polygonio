defmodule Polygon.Trades do
  alias Polygon.TradesRequest

  # https://polygon.io/docs/stocks/get_v2_aggs_ticker__stocksticker__range__multiplier___timespan___from___to
  # /v3/trades/{ticker}
  @spec request(Tesla.Client.t(), TradesRequest.t() | map()) :: {:error, any} | {:ok, map}
  def request(client, %TradesRequest{} = req) do
    with {:ok, %{body: %{"status" => status}} = result} when status in ~w(OK DELAYED) <-
           Tesla.get(client, TradesRequest.to_url(req)) do
      {:ok, result.body}
    else
      {:ok, %{body: %{"status" => "NOT_AUTHORIZED"}}} -> {:error, :not_authorized}
      {:ok, result} -> {:error, result}
      {:error, reason} -> {:error, reason}
    end
  end

  def request(client, params) when is_map(params) do
    case TradesRequest.build(params) do
      {:ok, req} -> request(client, req)
      {:error, changeset} -> {:error, changeset}
    end
  end
end

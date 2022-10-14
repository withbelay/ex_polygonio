defmodule Polygon.DailyOpenClose do
  alias Polygon.DailyOpenCloseRequest
  # https://polygon.io/docs/stocks/get_v1_open-close__stocksticker___date

  @spec request(Tesla.Client.t(), DailyOpenCloseRequest.t() | map()) ::
          {:error, any} | {:ok, map()}
  def request(client, %DailyOpenCloseRequest{} = req) do
    with {:ok, result} <- Tesla.get(client, DailyOpenCloseRequest.to_url(req)) do
      {:ok, result.body}
      # Response.build(result.body)
    end
  end

  def request(client, params) when is_map(params) do
    case DailyOpenCloseRequest.build(params) do
      {:ok, req} -> request(client, req)
      {:error, changeset} -> {:error, changeset}
    end
  end
end

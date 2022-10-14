defmodule Polygon.Stocks do
  defdelegate aggregates(client, req), to: Polygon.Stocks.Aggregates, as: :request
  defdelegate quotes(client, req), to: Polygon.Stocks.Quotes, as: :request
  defdelegate trades(client, req), to: Polygon.Stocks.Trades, as: :request
  defdelegate daily_open_close(client, req), to: Polygon.Stocks.DailyOpenClose, as: :request
end

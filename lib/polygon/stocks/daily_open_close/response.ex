defmodule Polygon.Stocks.DailyOpenClose.Response do
  use Ecto.Schema
  import Ecto.Changeset
  @primary_key false
  embedded_schema do
    field(:after_hours, :decimal)
    field(:close, :decimal)
    field(:from, :date)
    field(:high, :decimal)
    field(:low, :decimal)
    field(:open, :decimal)
    field(:pre_market, :decimal)
    field(:status, :string)
    field(:symbol, :string)
    field(:volume, :float)
  end

  @spec build(map) :: map
  def build(params) do
    params =
      params
      |> Map.put("after_hours", params["afterHours"])
      |> Map.put("pre_market", params["preMarket"])

    %__MODULE__{}
    |> cast(params, ~w(after_hours close from high low open pre_market status symbol volume)a)
    |> apply_changes()
  end
end

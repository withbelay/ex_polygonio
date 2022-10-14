defmodule Polygon.Stocks.Trades.Response do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field(:next_url, :string)
    field(:request_id, :string)
    field(:status, :string)
    embeds_many(:results, Polygon.Stocks.Trades.TradeResult)
  end

  def build(params) do
    result =
      %__MODULE__{}
      |> cast(params, ~w(next_url request_id status)a)
      |> cast_embed(:results)
      |> apply_changes()

    {:ok, result}
  end
end

defmodule Polygon.Stocks.Trades.TradeResult do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    # field(:conditions, :integer)
    field(:correction, :integer)
    field(:exchange, :integer)
    field(:id, :string)
    field(:participant_timestamp, :integer)
    field(:price, :decimal)
    field(:sequence_number, :integer)
    field(:sip_timestamp, :integer)
    field(:size, :float)
    field(:tape, :integer)
    field(:trf_id, :integer)
    field(:trf_timestamp, :integer)
  end

  def changeset(%__MODULE__{} = result, params) do
    result
    |> cast(
      params,
      ~w( correction exchange id participant_timestamp price sequence_number sip_timestamp size tape trf_id trf_timestamp)a
    )

    # |> apply_changes()
  end
end

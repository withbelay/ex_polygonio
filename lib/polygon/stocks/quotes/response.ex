defmodule Polygon.Stocks.Quotes.Response do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field(:next_url, :string)
    field(:request_id, :string)
    field(:status, :string)
    embeds_many(:results, Polygon.Stocks.Quotes.QuoteResult)
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

defmodule Polygon.Stocks.Quotes.QuoteResult do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field(:ask_exchange, :integer)
    field(:ask_price, :decimal)
    field(:ask_size, :float)
    field(:bid_exchange, :integer)
    field(:bid_price, :decimal)
    field(:bid_size, :float)
    # field(:conditions, :integer)
    # field(:indicators, :integer)
    field(:participant_timestamp, :integer)
    field(:sequence_number, :integer)
    field(:sip_timestamp, :integer)
    field(:tape, :integer)
    field(:trf_timestamp, :integer)
  end

  def changeset(%__MODULE__{} = result, params) do
    result
    |> cast(
      params,
      ~w(ask_exchange ask_price ask_size bid_exchange bid_price bid_size participant_timestamp sequence_number sip_timestamp tape trf_timestamp)a
    )

    # |> apply_changes()
  end
end

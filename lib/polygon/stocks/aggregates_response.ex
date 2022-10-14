defmodule Polygon.Stocks.AggregateResult do
  use Ecto.Schema
  import Ecto.Changeset
  @primary_key false
  embedded_schema do
    field(:c, :decimal)
    field(:h, :decimal)
    field(:l, :decimal)
    field(:n, :integer)
    field(:o, :decimal)
    field(:t, :integer)
    field(:v, :decimal)
    field(:vw, :decimal)
  end

  def changeset(%__MODULE__{} = result, params) do
    result
    |> cast(params, ~w(c h l n o t v vw)a)
  end
end

defmodule Polygon.Stocks.AggregatesResponse do
  use Ecto.Schema
  import Ecto.Changeset

  # @type t :: %__MODULE__{
  #         ticker: String.t(),
  #         adjusted: boolean(),
  #         queryCount: integer(),
  #         request_id: String.t(),
  #         results_count: integer(),
  #         status: String.t(),
  #         results: list(%AggregateResult{})
  #       }
  @derive {Jason.Encoder, except: [:__struct__]}
  @primary_key false
  embedded_schema do
    field(:ticker, :string)
    field(:adjusted, :boolean)
    field(:queryCount, :integer)
    field(:request_id, :string)
    field(:results_count, :integer)
    field(:status, :string)

    embeds_many(:results, Polygon.Stocks.AggregateResult)
  end

  def build(params) do
    result =
      %__MODULE__{}
      |> cast(params, ~w(ticker adjusted queryCount request_id results_count status)a)
      |> cast_embed(:results)
      |> apply_changes()

    {:ok, result}
  end
end

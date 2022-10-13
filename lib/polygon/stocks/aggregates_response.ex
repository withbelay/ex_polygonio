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
  embedded_schema do
    field(:ticker, :string)
    field(:adjusted, :boolean)
    field(:queryCount, :integer)
    field(:request_id, :string)
    field(:results_count, :integer)
    field(:status, :string)

    embeds_many :results, AggregateResult do
      field(:c, :decimal)
      field(:h, :decimal)
      field(:l, :decimal)
      field(:n, :integer)
      field(:o, :decimal)
      field(:t, :integer)
      field(:v, :decimal)
      field(:vw, :decimal)
    end
  end

  def build(params) do
    %__MODULE__{}
    |> cast(params, ~w(c h l n o t v vw)a)
    |> apply_changes()
  end
end

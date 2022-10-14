defmodule Polygon.DailyOpenCloseRequest do
  use Ecto.Schema
  import Ecto.Changeset

  # @type t :: %__MODULE__{
  #         ticker: String.t(),
  #         multiplier: non_neg_integer(),
  #         timespan: @timespan(),
  #         from: DateTime.t(),
  #         to: DateTime.t(),
  #         adjusted: boolean(),
  #         sort: @sort(),
  #         limit: non_neg_integer()
  #       }
  @derive {Jason.Encoder, except: [:__struct__]}
  embedded_schema do
    field(:ticker, :string)
    field(:date, :date)
    field(:adjusted, :boolean, default: true)
  end

  def to_url(%__MODULE__{} = req) do
    # Need to format the to / from dates
    # Either a date with the format YYYY-MM-DD or a millisecond timestamp.
    date = Date.to_string(req.date)
    "/v1/open-close/#{req.ticker}/#{date}?adjusted=#{req.adjusted}"
  end

  @spec build(map) :: {:error, Ecto.Changeset.t()} | {:ok, map}
  def build(params) do
    %__MODULE__{}
    |> cast(params, ~w(ticker date adjusted)a)
    |> validate_required(~w(ticker date)a)
    |> apply_action(:ignore)
  end
end

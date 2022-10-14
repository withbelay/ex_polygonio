defmodule Polygon.AggregatesRequest do
  use Ecto.Schema
  import Ecto.Changeset

  @type(timespan() :: :minute, :hour, :day, :week, :month, :quarter, :year)
  @type(sort() :: :asc, :desc)

  @type t() :: %__MODULE__{
          stocks_ticker: String.t(),
          multiplier: non_neg_integer(),
          timespan: timespan(),
          from: DateTime.t(),
          to: DateTime.t(),
          adjusted: boolean(),
          sort: sort(),
          limit: non_neg_integer()
        }
  @derive {Jason.Encoder, except: [:__struct__]}
  embedded_schema do
    field(:stocks_ticker, :string)
    field(:multiplier, :integer, default: 1)

    field(:timespan, Ecto.Enum,
      values: ~w(minute hour day week month quarter year)a,
      default: :minute
    )

    field(:from, :utc_datetime)
    field(:to, :utc_datetime)
    field(:adjusted, :boolean, default: true)
    field(:sort, Ecto.Enum, values: ~w(asc desc)a, default: :asc)
    field(:limit, :integer, default: 50_000)
  end

  def to_url(%__MODULE__{} = req) do
    # Need to format the to / from dates
    # Either a date with the format YYYY-MM-DD or a millisecond timestamp.
    from = DateTime.to_unix(req.from, :millisecond)
    to = DateTime.to_unix(req.to, :millisecond)

    "/v2/aggs/ticker/#{req.stocks_ticker}/range/#{req.multiplier}/#{req.timespan}/#{from}/#{to}?adjusted=#{req.adjusted}&sort=#{req.sort}&limit=#{req.limit}"
  end

  def build(params) do
    %__MODULE__{}
    |> cast(params, ~w(stocks_ticker multiplier timespan from to adjusted sort limit)a)
    |> validate_required(~w(stocks_ticker multiplier timespan from to)a)
    |> apply_action(:ignore)
  end
end

defmodule Polygon.Stocks.Quotes.Request do
  use Ecto.Schema
  import Ecto.Changeset

  @type t() :: %__MODULE__{
          stocks_ticker: String.t(),
          timestamp: DateTime.t(),
          timestamp_lt: DateTime.t(),
          timestamp_lte: DateTime.t(),
          timestamp_gt: DateTime.t(),
          timestamp_gte: DateTime.t(),
          limit: non_neg_integer()
        }
  @derive {Jason.Encoder, except: [:__struct__]}
  embedded_schema do
    field(:stocks_ticker, :string)
    field(:timestamp, :utc_datetime)
    field(:timestamp_lt, :utc_datetime)
    field(:timestamp_lte, :utc_datetime)
    field(:timestamp_gt, :utc_datetime)
    field(:timestamp_gte, :utc_datetime)
    field(:limit, :integer, default: 50_000)
  end

  def to_url(%__MODULE__{} = req) do
    # Need to format the to / from dates
    # Either a date with the format YYYY-MM-DD or a millisecond timestamp.
    url = "/v3/quotes/#{req.stocks_ticker}"

    # filter the optional queries components
    query =
      req
      |> Map.from_struct()
      |> Map.filter(fn
        {_key, nil} -> false
        {:stocks_ticker, _} -> false
        _ -> true
      end)
      |> URI.encode_query(:rfc3986)

    case String.length(query) do
      0 -> url
      _ -> url <> "?#{query}"
    end
  end

  def build(params) do
    %__MODULE__{}
    |> cast(
      params,
      ~w(stocks_ticker timestamp timestamp_lt timestamp_lte timestamp_gt timestamp_gte limit)a
    )
    |> validate_required(~w(stocks_ticker)a)
    |> apply_action(:ignore)
  end
end

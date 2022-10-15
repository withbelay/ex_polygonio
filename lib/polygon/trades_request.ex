defmodule Polygon.TradesRequest do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ecto.Changeset
  require Logger

  @type t() :: %__MODULE__{
          ticker: String.t(),
          timestamp: DateTime.t(),
          timestamp_lt: DateTime.t(),
          timestamp_lte: DateTime.t(),
          timestamp_gt: DateTime.t(),
          timestamp_gte: DateTime.t(),
          limit: non_neg_integer()
        }
  @derive {Jason.Encoder, except: [:__struct__]}
  embedded_schema do
    field(:ticker, :string)
    field(:timestamp, :string)
    field(:timestamp_lt, :string)
    field(:timestamp_lte, :string)
    field(:timestamp_gt, :string)
    field(:timestamp_gte, :string)
    field(:limit, :integer)
  end

  def to_url(%__MODULE__{} = req) do
    # Need to format the to / from dates
    # Either a date with the format YYYY-MM-DD or a millisecond timestamp.
    # TODO: PART of this url is the only difference between it and quotes/request.ex
    url = "/v3/trades/#{req.ticker}"

    # filter the optional queries components
    query =
      req
      |> Map.from_struct()
      |> Map.filter(fn
        {_key, nil} -> false
        {:ticker, _} -> false
        _ -> true
      end)
      |> Enum.map(fn {key, value} ->
        {String.replace(Atom.to_string(key), "_", "."), value}
      end)
      |> URI.encode_query(:rfc3986)

    case String.length(query) do
      0 -> url
      _ -> url <> "?#{query}"
    end
  end

  # defp serialize(%DateTime{} = value), do: DateTime.to_unix(value, :nanosecond)
  # defp serialize(%Date{} = value), do: Date.to_string(value)
  # defp serialize(value), do: value

  def build(params) do
    params = convert_dates_to_strings(params)

    %__MODULE__{}
    |> cast(
      params,
      ~w(ticker limit timestamp timestamp_lt timestamp_lte timestamp_gt timestamp_gte)a
    )
    |> validate_required(~w(ticker)a)
    |> validate_one_at_most(~w(timestamp timestamp_lt timestamp_lte timestamp_gt timestamp_gte)a)
    |> apply_action(:ignore)
  end

  defp convert_dates_to_strings(params) do
    keys = Map.keys(params)

    timestamp_keys =
      keys
      |> Enum.filter(
        &(&1
          |> Kernel.to_string()
          |> String.starts_with?("timestamp"))
      )

    updated_dates =
      timestamp_keys
      |> Enum.map(&{&1, convert_date_to_string(params[&1])})
      |> Map.new()

    Map.merge(params, updated_dates)
  end

  defp convert_date_to_string(date) when is_nil(date), do: nil
  defp convert_date_to_string(%Date{} = date), do: Date.to_string(date)

  defp convert_date_to_string(%DateTime{} = date),
    do: DateTime.to_unix(date, :nanosecond) |> to_string()

  defp convert_date_to_string(date) when is_binary(date), do: date

  defp validate_one_at_most(%Changeset{} = changeset, fields, _opts \\ []) do
    num_timestamps =
      fields
      |> Enum.map(&get_field(changeset, &1))
      |> Enum.filter(&(!is_nil(&1)))
      |> Enum.count()

    if num_timestamps < 2,
      do: changeset,
      else: add_error(changeset, :timestamp, "Only 1 timestamp filter can be set")
  end
end

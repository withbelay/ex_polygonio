defmodule Polygon.TradesOrQuotesRequestTest do
  alias Polygon.TradesOrQuotesRequest
  use ExUnit.Case, async: true
  import ExUnit.CaptureLog
  require Logger

  {:ok, datetime, _} = DateTime.from_iso8601("2022-10-15T09:31:54Z")

  inputs = [
    # value  result
    # ["", "/v3/trades/AAPL"],
    [nil, "/v3/trades/AAPL"],
    [datetime, "/v3/trades/AAPL?FIELD=1665826314000000000"],
    [Date.from_iso8601!("2022-10-15"), "/v3/trades/AAPL?FIELD=2022-10-15"],
    ["2022-10-16", "/v3/trades/AAPL?FIELD=2022-10-16"]
  ]

  for [timestamp_val, expected_url] <- inputs do
    @timestamp_val timestamp_val
    @expected_url expected_url
    test "to_url/1 timestamp: [#{@timestamp_val}]" do
      for timestamp_field <- ~w(timestamp timestamp_lt timestamp_lte timestamp_gt timestamp_gte) do
        assert {:ok, req} =
                 %{"ticker" => "AAPL"}
                 |> Map.put(timestamp_field, @timestamp_val)
                 |> TradesOrQuotesRequest.build()

        timestamp_url_field = String.replace(timestamp_field, "_", ".")

        assert String.replace(@expected_url, "FIELD", timestamp_url_field) ==
                 TradesOrQuotesRequest.to_url("/v3/trades/", req)
      end
    end
  end

  test "build/1 - valid" do
    assert {:error, changeset} = TradesOrQuotesRequest.build(%{})

    assert {:error, changeset} =
             TradesOrQuotesRequest.build(%{
               ticker: "AAPL",
               timestamp: DateTime.utc_now(),
               timestamp_lt: DateTime.utc_now()
             })
  end
end

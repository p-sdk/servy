defmodule HttpServerTest do
  use ExUnit.Case

  alias Servy.HttpServer

  test "accepts a request on a socket and sends back a response" do
    spawn HttpServer, :start, [4001]

    urls = [
      "http://localhost:4001/wildthings",
      "http://localhost:4001/bears",
      "http://localhost:4001/bears/1",
      "http://localhost:4001/wildlife",
      "http://localhost:4001/api/bears"
    ]

    urls
    |> Enum.map(&Task.async HTTPoison, :get, [&1])
    |> Enum.map(&Task.await/1)
    |> Enum.each(&assert_succesful_response/1)
  end

  defp assert_succesful_response({:ok, response}) do
    assert response.status_code == 200
  end
end

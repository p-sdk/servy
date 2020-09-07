defmodule HttpServerTest do
  use ExUnit.Case

  alias Servy.HttpServer

  test "accepts a request on a socket and sends back a response" do
    num_requests = 5

    spawn HttpServer, :start, [4001]

    url = "http://localhost:4001/wildthings"

    1..num_requests
    |> Enum.map(fn _ -> Task.async HTTPoison, :get, [url] end)
    |> Enum.map(&Task.await/1)
    |> Enum.each(&assert_succesful_response/1)
  end

  defp assert_succesful_response({:ok, response}) do
    assert response.status_code == 200
    assert response.body == "Bears, Lions, Tigers"
  end
end

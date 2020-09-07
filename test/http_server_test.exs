defmodule HttpServerTest do
  use ExUnit.Case

  alias Servy.HttpServer

  test "accepts a request on a socket and sends back a response" do
    parent = self()
    num_requests = 5

    spawn HttpServer, :start, [4001]

    for _ <- 1..num_requests do
      spawn fn ->
        send parent, HTTPoison.get "http://localhost:4001/wildthings"
      end
    end

    for _ <- 1..num_requests do
      receive do
        {:ok, response} ->
          assert response.status_code == 200
          assert response.body == "Bears, Lions, Tigers"
      end
    end
  end
end

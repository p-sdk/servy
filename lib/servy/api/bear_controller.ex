defmodule Servy.Api.BearController do
  import Servy.Plugins, only: [put_resp_content_type: 2]

  def index(conv) do
    json =
      Servy.Wildthings.list_bears
      |> Poison.encode!

    conv = put_resp_content_type(conv, "application/json")

    %{ conv | status: 200, resp_body: json }
  end
end

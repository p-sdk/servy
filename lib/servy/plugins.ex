defmodule Servy.Plugins do
  alias Servy.Conv

  def track(%Conv{status: 404, path: path} = conv) do
    if Mix.env != :test do
      IO.puts "Warning: #{path} is on the loose!"
      Servy.FourOhFourCounter.bump_count path
    end
    conv
  end

  def track(%Conv{} = conv), do: conv

  def rewrite_path(%Conv{path: "/wildlife"} = conv) do
    %{ conv | path: "/wildthings" }
  end

  def rewrite_path(%Conv{path: path} = conv) do
    regex = ~r{\/(?<thing>\w+)\?id=(?<id>\d+)}
    captures = Regex.named_captures(regex, path)
    rewrite_path_captures(conv, captures)
  end

  def rewrite_path_captures(%Conv{} = conv, %{"thing" => thing, "id" => id}) do
    %{ conv | path: "/#{thing}/#{id}" }
  end

  def rewrite_path_captures(%Conv{} = conv, nil), do: conv

  def log(%Conv{} = conv) do
    if Mix.env == :dev do
      IO.inspect conv
    end
    conv
  end

  def put_resp_content_type(%Conv{} = conv, type) do
    headers = Map.put(conv.resp_headers, "Content-Type", type)
    %{ conv | resp_headers: headers }
  end

  def put_content_length(%Conv{} = conv) do
    headers = Map.put(conv.resp_headers, "Content-Length", byte_size(conv.resp_body))
    %{ conv | resp_headers: headers }
  end
end

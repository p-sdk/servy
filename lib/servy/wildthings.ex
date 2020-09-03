defmodule Servy.Wildthings do
  @db_path Path.expand("../../db", __DIR__)

  alias Servy.Bear

  defp read_json(path) do
    case File.read(path) do
      {:ok, contents} ->
        contents
      {:error, reason} ->
        IO.inspect "Error reading #{path}: #{reason}"
        "[]"
    end
  end

  def list_bears do
    @db_path
    |> Path.join("bears.json")
    |> read_json
    |> Poison.decode!(as: %{"bears" => [%Bear{}]})
    |> Map.get("bears")
  end

  def get_bear(id) when is_integer(id) do
    Enum.find(list_bears(), fn(b) -> b.id == id end)
  end

  def get_bear(id) when is_binary(id) do
    id |> String.to_integer |> get_bear
  end
end

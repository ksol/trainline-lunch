require IEx

defmodule TrainlineLunchWeb.PageController do
  use TrainlineLunchWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def piplettes(conn, _params) do
    message = "lespiplettesruelaffitteparis"
      |> get_last_message
      |> extract_relevant
      |> format

    text conn, message
  end

  def cocottes(conn, _params) do
    message = "SuperCocotteParis"
      |> get_last_message("message,full_picture")
      |> extract_relevant
      |> format

    text conn, message
  end

  defp get_last_message(page_id) do
    page_id |> Facebook.page(System.get_env("FB_TOKEN"), "posts.order(reverse_chronological).limit(1){message}")
  end

  defp get_last_message(page_id, fields) do
    page_id |> Facebook.page(System.get_env("FB_TOKEN"), "posts.order(reverse_chronological).limit(1){#{fields}}")
  end

  defp extract_relevant(response) do
    {:json, %{"id" => _id, "posts" => %{"data" => [message]}}} = response

    message
  end

  defp format(message) do
    if message["full_picture"] do
      "#{message["message"]} - #{message["full_picture"]}"
    else
      message["message"]
    end
  end
end

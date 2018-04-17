require IEx

defmodule TrainlineLunchWeb.PageController do
  use TrainlineLunchWeb, :controller

  def piplettes(conn, _params) do
    data = "lespiplettesruelaffitteparis"
      |> get_last_message
      |> extract_relevant

    message = format(data)
    tags = og_tags("Les Piplettes", data)

    render conn, "show.html", message: message, og_tags: tags
  end

  def cocottes(conn, _params) do
    data = "SuperCocotteParis"
      |> get_last_message("created_time,message,full_picture")
      |> extract_relevant

    message = format(data)
    tags = og_tags("Super Cocotte", data)

    render conn, "show.html", message: message, og_tags: tags
  end

  defp get_last_message(page_id) do
    page_id |> Facebook.page(System.get_env("FB_TOKEN"), "posts.order(reverse_chronological).limit(1){created_time,message}")
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

  def formatted_date({:ok, datetime, _}) do
    string = datetime
    |> shift_zone!("Europe/Paris")
    |> Calendar.Strftime.strftime!("%d/%m/%Y %H:%M")

    " (#{string})"
  end

  def formatted_date({:error, _}) do
    ""
  end

  def formatted_date(data) do
    data["created_time"] |> DateTime.from_iso8601 |> formatted_date
  end

  defp shift_zone!(nil, _time_zone) do
    nil
  end

  defp shift_zone!(timestamp, time_zone) do
    timestamp
    |> Calendar.DateTime.shift_zone!(time_zone)
  end

  defp og_tags(title, data) do
    tags = %{
      "og:site_name" => "Trailine Europe — MANGER",
      "og:title" => "#{title}#{formatted_date(data)}",
      "og:description" => data["message"],
      "og:image" => data["full_picture"]
    }

    tags |> Enum.filter(fn({_k, v}) -> v end)
  end
end

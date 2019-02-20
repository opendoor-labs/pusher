defmodule Pusher.PublishController do
  require Logger

  use Pusher.Web, :controller

  plug :authenticate

  def publish(conn, params) do
    broadcast_event(params)
    json conn, %{}
  end

  def bulk(conn, params) do
    broadcast_events(params["events"])
    json conn, %{}
  end

  defp broadcast_event(event_params = %{ "topic" => topic, "event" => event }) do
    message = event_params["payload"] || %{}
    Pusher.Endpoint.broadcast! topic, event, message
    Logger.info("Published event to #{topic}")
  end

  defp broadcast_event(_), do: :ok

  defp broadcast_events([event|rest]) do
    broadcast_event(event)
    broadcast_events(rest)
  end

  defp broadcast_events([]), do: :ok
  defp broadcast_events(nil), do: :ok

  defp authenticate(conn, _) do
    secret = Application.get_env(:pusher, :authentication)[:secret]
    if Plug.Crypto.secure_compare(hd(get_req_header(conn, "authorization")), secret) do
      conn
    else
      conn |> send_resp(401, "") |> halt
    end
  end
end

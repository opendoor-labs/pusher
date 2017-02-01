defmodule Pusher.EventChannel do
  use Phoenix.Channel
  import Guardian.Phoenix.Socket
  alias Pusher.Presence

  def join("public:" <> _topic_id, _auth_msg, socket) do
    {:ok, socket}
  end

  def join(topic, %{ "guardian_token" => token }, socket) do
    case sign_in(socket, token) do
      {:ok, authed_socket, guardian_params} ->
        send(self, :after_join)
        claims = guardian_params[:claims]
        if permitted_topic?(claims["listen"], topic) do
          { :ok, %{ message: "Joined" }, authed_socket }
        else
          { :error, :authentication_required }
        end
      {:error, reason} ->
          { :error, reason }
    end
  end

  def join(_room, _payload, _socket) do
    { :error, :authentication_required }
  end

  def handle_info(:after_join, socket) do
    push socket, "presence_state", Presence.list(socket)
    claims = current_claims(socket)
    is_map = Pusher.IsAHelper.is_a_map?(claims["sub"])
    if(is_map && Map.has_key?(claims["sub"], "email")) do
      {:ok, _} = Presence.track(socket, current_resource(socket)["email"], %{
        online_at: :os.system_time(:milli_seconds)
      })
    end
    {:noreply, socket}
  end

  def handle_in(event, payload, socket = %{ topic: "public:" <> _ }) do
    broadcast! socket, event, payload
    { :noreply, socket }
  end

  def handle_in(event, payload, socket) do
    claims = current_claims(socket)
    if(permitted_topic?(claims["publish"], socket.topic)) do
      broadcast! socket, event, payload
      { :noreply, socket }
    else
      { :reply, :error, socket }
    end
  end

  def permitted_topic?(nil, _), do: false
  def permitted_topic?([], _), do: false

  def permitted_topic?(permitted_topics, topic) do
    matches = fn permitted_topic ->
      pattern = String.replace(permitted_topic, ":*", ":.*")
      Regex.match?(~r/\A#{pattern}\z/, topic)
    end
    Enum.any?(permitted_topics, matches)
  end
end

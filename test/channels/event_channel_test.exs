defmodule Pusher.EventChannelTest do
  use Pusher.ChannelCase
  alias Pusher.EventSocket

  setup do
    {:ok, socket} = connect(EventSocket, %{})
    {:ok, _, socket} = subscribe_and_join(socket, "public:deploys")
    default_claims = %{
      "exp" => Guardian.Utils.timestamp + 100_00,
      "aud" => "token",
      "jti" => "hi_there_fella",
      "iat" => Guardian.Utils.timestamp,
      "iss" => "MyApp",
    }
    {:ok, socket: socket, default_claims: default_claims}
  end

  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from! socket, "msg", %{"version" => "sha123"}
    assert_push "msg", %{"version" => "sha123"}
  end

  test "allows publishing to public channels", %{socket: socket} do
    push socket, "blah", %{"hello" => "world"}
    assert_push "blah", %{"hello" => "world"}
  end

  test "pervents joining channels with no jwt token", %{socket: socket} do
    {:error, :authentication_required} = subscribe_and_join(socket, "private:123")
  end

  test "allows joining permitted channels claimed channels", %{socket: socket, default_claims: d_claims} do
    data = Dict.put(d_claims, "listen", ["private:*"])
    {:ok, jwt, _} = Guardian.encode_and_sign("User:1", "token", data)
    {:ok, _, _} = subscribe_and_join(socket, "private:123", %{"guardian_token" => jwt})
  end

  test "prevents joining unpermitted channels", %{socket: socket, default_claims: d_claims} do
    data = Dict.put(d_claims, "listen", ["private:*"])

    {:ok, jwt, _} = Guardian.encode_and_sign("User:1", "token", data)
    {:error, :authentication_required} = subscribe_and_join(socket, "super_secret:123", %{"guardian_token" => jwt})
  end

  test "lets messages be published on private channels", %{socket: socket, default_claims: d_claims} do
    data = Dict.put(d_claims, "listen", ["private:*"])
           |> Dict.put("publish", ["private:*"])
    {:ok, jwt, _} = Guardian.encode_and_sign("User:1", "token", data)
    {:ok, _, socket} = subscribe_and_join(socket, "private:123:456", %{"guardian_token" => jwt})

    push socket, "msg", %{"hello" => "world"}
    assert_push "msg", %{"hello" => "world"}
  end

  test "denies private channel publishing if missing key", %{socket: socket, default_claims: d_claims} do
    data = Dict.put(d_claims, "listen", ["private:*"])
          |> Dict.put("publish", [])
    {:ok, jwt, _} = Guardian.encode_and_sign("User:1", "token", data)
    {:ok, _, socket} = subscribe_and_join(socket, "private:123:456", %{"guardian_token" => jwt})
    ref = push socket, "msg", %{"ping" => "pong"}
    assert_reply ref, :error
  end
end

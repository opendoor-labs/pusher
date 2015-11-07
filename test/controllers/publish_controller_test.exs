defmodule Pusher.PublishControllerTest do
  use Pusher.ConnCase
  use Pusher.ChannelCase

  setup do
    @endpoint.subscribe(self(), "public:deploys")
    :ok
  end

  test "publishes messages with a valid secret" do
    conn = conn()
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", Application.get_env(:pusher, :authentication)[:secret])
    resp = post conn, "/api/publish", %{topic: "public:deploys", event: "msg",  payload: %{version: "sha123"}}
    assert resp.status == 200
    assert_broadcast "msg", %{"version" => "sha123"}
  end

  test "does not publish messages with a invalid secret" do
    conn = conn()
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "BAD")
    resp = post conn, "/api/publish", %{topic: "public:deploys", event: "msg",  payload: %{version: "sha123"}}
    assert resp.status == 401
  end

  test "publishes bulk messages" do
    conn = conn()
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", Application.get_env(:pusher, :authentication)[:secret])
    resp = post conn, "/api/publish/bulk", %{ events: [
        %{topic: "public:deploys", event: "msg",  payload: %{version: "sha123"} },
        %{topic: "public:deploys", event: "update",  payload: %{id: "123"} }
      ]
    }
    assert resp.status == 200
    assert_push "msg", %{"version" => "sha123"}
    assert_push "update", %{"id" => "123"}
  end
end

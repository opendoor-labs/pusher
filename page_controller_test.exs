defmodule Pusher.PageControllerTest do
  use Pusher.ConnCase
  use Pusher.ChannelCase

  alias Pusher.EventChannel

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, _, socket} = subscribe_and_join(EventChannel, "public:deploys")
    {:ok, socket: socket, conn: conn}
  end

  test "publishes messages", %{socket: socket, conn: conn} do
    conn = post conn(), "/api/publish", %{topic: "public:deploys", event: "msg",  payload: %{}}
    assert_push "msg", %{"version" => "sha123"}
  end
end

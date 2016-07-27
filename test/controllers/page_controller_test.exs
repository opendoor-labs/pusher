defmodule Pusher.PageControllerTest do
  use Pusher.ConnCase

  test "GET /" do
    conn = get build_conn(), "/"
    assert html_response(conn, 200) =~ "Pusher App!"
  end
end

defmodule Pusher.PageControllerTest do
  use Pusher.ConnCase

  test "GET /" do
    conn = get conn(), "/"
    assert html_response(conn, 200) =~ "Pusher App!"
  end
end

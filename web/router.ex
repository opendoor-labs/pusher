defmodule Pusher.Router do
  use Phoenix.Router
  use Honeybadger.Plug

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Pusher do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", Pusher do
    pipe_through :api

    post "/publish", PublishController, :publish
    post "/publish/bulk", PublishController, :bulk
  end
end

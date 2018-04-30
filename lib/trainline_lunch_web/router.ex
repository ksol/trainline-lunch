defmodule TrainlineLunchWeb.Router do
  use TrainlineLunchWeb, :router

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

  scope "/", TrainlineLunchWeb do
    pipe_through :browser # Use the default browser stack

    get "/piplettes", PageController, :piplettes
    get "/cocottes", PageController, :cocottes
    get "/tour_thai", PageController, :tour_thai
  end

  # Other scopes may use custom stacks.
  # scope "/api", TrainlineLunchWeb do
  #   pipe_through :api
  # end
end

defmodule Endpoint do
  use Plug.Router

  alias Service.{PromiseService, FrequencyService, TargetService}

  plug(Plug.Logger)

  plug :match

  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)

  plug :dispatch

  forward "/promises", to: Routes.PromiseRouter
  forward "/frequencies", to: Routes.FrequencyRouter
  forward "/targets", to: Routes.TargetRouter

  match _ do
    send_resp(conn, 404, "oops!")
  end
end
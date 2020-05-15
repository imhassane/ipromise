defmodule Routes.TargetRouter do
  use BaseRouter
  alias Service.TargetService

  get "/:frequency_id" do
    TargetService.get_frequency_targets(frequency_id)
    |> handle_response(conn)
  end

  get "/details/:id" do
    TargetService.get_target(id)
    |> handle_response(conn)
  end

  post "/:frequency_id" do
    TargetService.add_target(frequency_id, conn.body_params)
    |> handle_response(conn)
  end

  put "/:id" do
    TargetService.update_target(id, conn.body_params)
    |> handle_response(conn)
  end

  delete "/:id" do
    TargetService.delete_target(id)
    |> handle_response(conn)
  end

  match _ do
    send_resp(conn, 404, "oops!")
  end
end
defmodule Routes.PromiseRouter do
  use BaseRouter
  alias Service.PromiseService


  get "/" do
    PromiseService.get_promises() |> handle_response(conn)
  end

  get "/:id" do
    PromiseService.get_promise(id) |> handle_response(conn)
  end

  post "/" do
    PromiseService.add_promise(conn.body_params)
    |> handle_response(conn)
  end

  put "/:id" do
    PromiseService.update_promise(id, conn.body_params)
    |> handle_response(conn)
  end

  delete "/:id" do
    PromiseService.delete_promise(id)
    |> handle_response(conn)
  end
end
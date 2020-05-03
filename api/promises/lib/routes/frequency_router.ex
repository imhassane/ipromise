defmodule Routes.FrequencyRouter do
  use BaseRouter
  alias Service.FrequencyService

  post "/:promise_id" do
    FrequencyService.add_frequency(promise_id, conn.body_params)
    |> handle_response(conn)
  end

  put "/:promise_id" do
    FrequencyService.update_frequency(promise_id, conn.body_params)
    |> handle_response(conn)
  end

  delete "/:promise_id" do
    FrequencyService.delete_frequency(promise_id)
    |> handle_response(conn)
  end
end
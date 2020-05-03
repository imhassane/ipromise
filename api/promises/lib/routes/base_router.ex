defmodule BaseRouter do

  defmacro __using__([]) do
    quote do
      use Plug.Router

      plug :match
      plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
      plug :dispatch
    end
  end

  
end
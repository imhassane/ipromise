use Mix.Config

config :promises, database: "ipromise-promises"

import_config "#{Mix.env()}.exs"

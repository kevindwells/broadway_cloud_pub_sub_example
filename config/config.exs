# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# third-party users, it should be done in your "mix.exs" file.

# You can configure your application as:
#
#     config :broadway_cloud_pub_sub_example, key: :value
#
# and access this configuration in your application as:
#
#     Application.get_env(:broadway_cloud_pub_sub_example, :key)
#
# You can also configure a third-party app:
#
#     config :logger, level: :info
#

# Sets the project_id to satisfy Goth.Config and to build the Pub/Sub paths
config :goth, project_id: "example-project"

config :google_api_pub_sub,
  base_url: "http://" <> (System.get_env("PUBSUB_EMULATOR_HOST") || "localhost:8085")

config :broadway_cloud_pub_sub_example, PubSubExample.SetupTask,
  topic_id: "example-topic",
  subscription_id: "example-subscription"

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
# import_config "#{Mix.env()}.exs"

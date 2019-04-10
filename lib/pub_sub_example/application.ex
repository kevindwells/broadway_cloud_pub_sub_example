defmodule PubSubExample.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    {:ok, _} = Application.ensure_all_started(:goth)

    # List all child processes to be supervised
    children = [
      # Runs at application start to setup the emulator resources, and then exits.
      {PubSubExample.SetupTask, []},
      # Starts the MyBroadway process
      {PubSubExample.MyBroadway, my_broadway_opts()}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PubSubExample.Supervisor]

    Supervisor.start_link(children, opts)
  end

  defp my_broadway_opts() do
    project_id = PubSubExample.project_id()
    subscription_id = PubSubExample.get_env(PubSubExample.SetupTask)[:subscription_id]

    [subscription: "projects/#{project_id}/subscriptions/#{subscription_id}"]
  end
end

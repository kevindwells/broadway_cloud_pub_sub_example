defmodule PubSubExample.SetupTask do
  @moduledoc """
  Conveniences for working with the Cloud Pub/Sub emulator.
  """

  use Task, restart: :temporary
  alias PubSubExample.Client
  require Logger

  def start_link(_) do
    opts = PubSubExample.get_env(__MODULE__)

    Task.start_link(__MODULE__, :setup, [opts])
  end

  @doc """
  Ensures the required topic and subscription exist at the emulator.
  """
  def setup(opts) do
    with {:ok, _topic} <- ensure_topic_exists(opts[:topic_id]),
         {:ok, _subscription} <-
           ensure_subscription_exists(opts[:topic_id], opts[:subscription_id]) do
      :ok
    end
  end

  defp ensure_topic_exists(nil), do: config_error(:topic_id)

  defp ensure_topic_exists(topic_id) do
    case Client.create_topic(topic_id) do
      {:ok, topic} ->
        Logger.debug("Created topic #{topic.name}")
        {:ok, topic.name}

      {:error, %{status: 409}} ->
        {:ok, topic_id}

      {:error, reason} ->
        Logger.error("Could not create topic #{topic_id}, Reason: #{inspect(reason)}")
        {:error, reason}
    end
  end

  defp ensure_subscription_exists(_, nil), do: config_error(:subscription_id)

  defp ensure_subscription_exists(topic_id, name) do
    case Client.create_subscription(topic_id, name) do
      {:ok, subscription} ->
        Logger.debug("Created subscription #{subscription.name}")
        {:ok, subscription.name}

      {:error, %{status: 409}} ->
        {:ok, name}

      {:error, reason} ->
        Logger.error("Could not create subscription #{name}, Reason: #{inspect(reason)}")
    end
  end

  defp config_error(key) do
    raise """
    Configuration error, #{key} not set.
    Please check the configuration for :broadway_cloud_pub_sub_example
    """
  end
end

defmodule PubSubExample do
  @moduledoc """
  Example project for consuming Cloud Pub/Sub messages with `BroadwayCloudPubSub`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> PubSubExample.hello()
      :world

  """
  def hello do
    :world
  end

  @doc """
  Returns a value from the application config.
  """
  def get_env(key, default \\ nil) do
    Application.get_env(:broadway_cloud_pub_sub_example, key, default)
  end

  @doc """
  Returns the `:project_id` from the `Goth` config.
  """
  def project_id do
    {:ok, project_id} = Goth.Config.get(:project_id)
    project_id
  end

  @doc """
  Publishes a message to the example topic.
  """
  def publish(message) when is_binary(message) do
    topic_id = get_env(PubSubExample.SetupTask)[:topic_id]

    with {:ok, _} <- PubSubExample.Client.publish_message(topic_id, message) do
      :ok
    end
  end
end

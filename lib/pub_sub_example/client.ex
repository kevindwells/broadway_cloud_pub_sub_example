defmodule PubSubExample.Client do
  @moduledoc """
  Minimal implementation of the Pub/Sub REST API v1.
  This module exists to simplify bootstrapping the example environment.
  """
  import GoogleApi.PubSub.V1.Api.Projects
  import PubSubExample, only: [project_id: 0]

  @doc """
  Creates a PubSub topic.
  """
  def create_topic(topic_id) do
    pubsub_projects_topics_create(
      conn(),
      project_id(),
      topic_id,
      body: %{}
    )
  end

  @doc """
  Fetches a PubSub topic by ID.
  """
  def get_topic(topic_id) do
    pubsub_projects_topics_get(conn(), project_id(), topic_id)
  end

  @doc """
  Creates a PubSub subscription for the given `topic_id`.
  """
  def create_subscription(topic_id, name) do
    project_id = project_id()

    pubsub_projects_subscriptions_create(
      conn(),
      project_id,
      name,
      body: %{
        topic: "projects/#{project_id}/topics/#{topic_id}"
      }
    )
  end

  @doc """
  Fetches a PubSub subscription by ID.
  """
  def get_subscription(subscription_id) do
    pubsub_projects_subscriptions_get(conn(), project_id(), subscription_id)
  end

  def publish_message(topic_id, message) do
    # Build the PublishRequest struct
    request = %GoogleApi.PubSub.V1.Model.PublishRequest{
      messages: [
        %GoogleApi.PubSub.V1.Model.PubsubMessage{
          data: Base.encode64(message)
        }
      ]
    }

    # Make the API request.
    pubsub_projects_topics_publish(
      conn(),
      project_id(),
      topic_id,
      body: request
    )
  end

  defp conn() do
    # Authenticate
    {:ok, token} = Goth.Token.for_scope("https://www.googleapis.com/auth/pubsub")
    GoogleApi.PubSub.V1.Connection.new(token.token)
  end
end

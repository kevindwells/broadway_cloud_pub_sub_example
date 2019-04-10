defmodule PubSubExample.MyBroadway do
  @moduledoc """
  Example pipeline for Google Cloud Pub/Sub with Broadway.
  """

  use Broadway
  alias Broadway.Message
  require Logger

  def start_link(opts) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producers: [
        default: [
          module: {BroadwayCloudPubSub.Producer, opts}
        ]
      ],
      processors: [
        default: [stages: 2]
      ]
    )
  end

  def handle_message(_processor_name, message, _context) do
    message = message |> Message.update_data(&process_data/1)

    Logger.debug("Received message from Cloud Pub/Sub: #{inspect(message)}")

    message
  end

  defp process_data(data) do
    # Do some calculations, generate a JSON representation, process images.
    data
  end
end

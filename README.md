# BroadwayCloudPubSub Example

This project contains an example application using [BroadwayCloudPubSub](https://hexdocs.pm/broadway_cloud_pub_sub) to fetch and acknowledge messages from Google Cloud Pub/Sub.


## Installation

Clone this repo, and then install the dependencies:

```sh
mix deps.get
```

To use the example app, you also need to install the [Cloud Pub/Sub emulator](https://cloud.google.com/pubsub/docs/emulator):

```sh
gcloud components install pubsub-emulator
gcloud components update
```

## Usage

### Running the emulator

First, start the emulator:

```sh
gcloud beta emulators pubsub start [options]
```

where `[options]` are command-line arguments supplied to the gcloud command-line tool. See [gcloud beta emulators pubsub](https://cloud.google.com/sdk/gcloud/reference/beta/emulators/pubsub/start) start for a complete list of options.

After you start the emulator, you should see a message that resembles the following:

```sh
...
[pubsub] This is the Cloud Pub/Sub fake.
[pubsub] Implementation may be incomplete or differ from the real system.
...
[pubsub] INFO: Server started, listening on 8085
```

### Running PubSubExample

To run the example app, open a new terminal.

You'll need to set the environment variables for the emulator connection. Running this command:

```sh
$(gcloud beta emulators pubsub env-init)
```
will automatically assign the `PUBSUB_EMULATOR_HOST` variable for this session. See the Pub/Sub emulator docs for more options for setting environment variables.

With our application environment configured, we can now start the application:

```sh
iex -S mix
```

When the iex session starts, you should see something like the following:

```sh
Erlang/OTP 21 [erts-10.3.2] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [hipe]

Interactive Elixir (1.8.1) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)>
```

Then, you should see output from the application that looks something like the following:

```sh
15:53:36.651 [debug] Created topic projects/example-project/topics/example-topic

15:53:36.660 [error] Unable to fetch events from Cloud Pub/Sub. Reason: %Tesla.Env{__client__: %Tesla.Client{adapter: nil, fun: nil, post: [], pre: [{Tesla.Middleware.Headers, :call, [[{"authorization", "Bearer 1234567890"}]]}]}, __module__: GoogleApi.PubSub.V1.Connection, body: "{\"error\":{\"code\":404,\"message\":\"Subscription does not exist\",\"status\":\"NOT_FOUND\"}}", headers: [{"content-length", "83"}, {"content-type", "application/json"}], method: :post, opts: [], query: [], status: 404, url: "http://localhost:8085/v1/projects/example-project/subscriptions/example-subscription:pull"}

15:53:36.668 [debug] Created subscription projects/example-project/subscriptions/example-subscription
```

When `PubSubExample.Application` starts, it runs a task to create the topic and subscription defined in `config/config.exs`, if they do not already exist.

The logged error indicates that `PubSubExample.MyBroadway` started successfully, and is listening for messages. It MyBroadway was unable to connect, you will continue to see error messages logged every `:receive_interval` seconds.

### Publishing Messages

Now that the application is running and MyBroadway is subscribed to the topic, we can publish and receive some messages:

```sh
iex(1)> PubSubExample.publish("Hello, world!")
:ok
iex(2)>
```

Once received, the message should be printed to the console:
```sh
iex(2)>
16:18:58.625 [debug] Received message from Cloud Pub/Sub: %Broadway.Message{acknowledger: {BroadwayCloudPubSub.GoogleApiClient, {BroadwayCloudPubSub.GoogleApiClient, #Reference<0.2672907561.3027763201.127864>}, "projects/example-project/subscriptions/example-subscription:8"}, batch_key: :default, batcher: :default, data: %GoogleApi.PubSub.V1.Model.PubsubMessage{attributes: nil, data: "aGVsbG8sIHdvcmxkMQ==", messageId: "4", publishTime: #DateTime<2019-04-10 23:18:58Z>}, status: :ok}
```

**Message Attributes**

You can also publish a message with just attributes:
```sh
iex(1)> PubSubExample.publish(%{"foo" => "bar"})
```

or, publish a message and attributes:

```sh
iex(1)> PubSubExample.publish({"Hello, Pub/Sub!", %{"foo" => "bar"}})
```

Broadway automatically takes care of acknowledging the message for you. If you're interested in learning how to handle failed messages, or to batch messages for more complex processing, see the [Broadway](https://hexdocs.pm/broadway) docs for more information.

Happy coding!

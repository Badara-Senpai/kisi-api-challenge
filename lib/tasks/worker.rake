# frozen_string_literal: true

require("google/cloud/pubsub")

namespace(:worker) do
  desc("Run the worker")
  task(run: :environment) do
    # See https://googleapis.dev/ruby/google-cloud-pubsub/latest/index.html

    puts("Worker starting...")

    project_id = "PUBSUB_TEST_PROJECT"
    pubsub = Google::Cloud::PubSub.new(project_id: project_id)

    sub = pubsub.subscription("SUBSCRIPTION1")

    subscriber = sub.listen do |received_message|
      puts("------------ Data start -----------")
      puts(received_message.message.data)
      puts("------------ Data end -----------")

      puts("Message was received. Data: #{received_message.message.data}, published at #{received_message.message.published_at}")

      ActiveJob::Base.execute(JSON.parse(received_message.message.data))

      received_message.acknowledge!
    rescue StandardError => e
      puts("Error: Failed to create the job name: #{e.message}")
    end

    subscriber.on_error do |exception|
      puts("Exception: #{exception.class} #{exception.message}")
    end

    at_exit do
      subscriber.stop!(30)
    end

    # Start background threads that will call the block passed to listen.
    subscriber.start

    # Block, letting processing threads continue in the background
    sleep
  end
end

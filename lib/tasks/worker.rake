# frozen_string_literal: true

require("google/cloud/pubsub")

namespace(:worker) do
  desc("Run the worker")
  task(run: :environment) do
    # See https://googleapis.dev/ruby/google-cloud-pubsub/latest/index.html

    puts("Worker starting...")

    project_id = "backend-challenge-362915"
    creds = Google::Cloud::PubSub::Credentials.new("backend-challenge-362915-1e96562be3f7.json")
    pubsub = Google::Cloud::PubSub.new(
      project_id: project_id,
      credentials: creds
    )

    sub = pubsub.subscription("my-topic-sub")

    subscriber = sub.listen do |received_message|
      puts("Message was received. Data: #{received_message.message.data}, published at #{received_message.message.published_at}")

      # process message
      received_message.message.data.constantize.perform_now
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

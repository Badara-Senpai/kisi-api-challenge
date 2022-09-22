# frozen_string_literal: true

require("google/cloud/pubsub")

class Pubsub
  # Find or create a topic.
  #
  # @param name [String] The name of the topic to find or create
  # @return [Google::Cloud::PubSub::Topic]
  def topic(name)
    client.topic(name) || client.create_topic(name)
  end

  private

  # Create a new client.
  #
  # @return [Google::Cloud::PubSub]
  def client
    project_id = "PUBSUB_TEST_PROJECT"
    @client ||= Google::Cloud::PubSub.new project_id: project_id
  end
end

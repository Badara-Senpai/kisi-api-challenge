# frozen_string_literal: true

module ActiveJob
  module QueueAdapters
    class PubsubAdapter
      # Enqueue a job to be performed.
      #
      # @param [ActiveJob::Base] job The job to be performed.
      def enqueue(job)
        puts("**************  Pub/Sub Adapter triggered  **************")

        puts("**************  Job inspect  **************")
        puts job.inspect
        puts("**************  Job inspect  **************")

        pubsub = Pubsub.new

        topic_name = "TOPIC1"
        begin
          pubsub.topic(topic_name).publish JSON.dump(job.serialize)
          puts("Message successfully published")
        rescue StandardError => e
          puts("Error: Failed to publish the message: #{e.message}")
        end
      end

      # Enqueue a job to be performed at a certain time.
      #
      # @param [ActiveJob::Base] job The job to be performed.
      # @param [Float] timestamp The time to perform the job.
      def enqueue_at(job, timestamp)
        enqueue job, timestamp: timestamp
      end
    end
  end
end

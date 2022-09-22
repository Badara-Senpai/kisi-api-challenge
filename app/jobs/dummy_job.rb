# frozen_string_literal: true

class DummyJob < ActiveJob::Base
  queue_as(:default)

  retry_on(wait: 5.minutes, attempts: 2)
  retry_on(Net::OpenTimeout, Timeout::Error, wait: :exponentially_longer, attempts: 5)

  def perform(*args)
    options = args.extract_options!

    puts("**************  Dummy triggered  **************")
    # Do something later
    puts(options)
    puts("**************  Dummy ended  **************")
  end
end

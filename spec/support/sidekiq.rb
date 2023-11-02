# https://github.com/philostler/rspec-sidekiq
RSpec::Sidekiq.configure do |config|
  # Clears all job queues before each example
  config.clear_all_enqueued_jobs = true # default => true

  # Whether to use terminal colours when outputting messages
  config.enable_terminal_colours = true # default => true

  # Warn when jobs are not enqueued to Redis but to a job array
  config.warn_when_jobs_not_processed_by_sidekiq = false # default => true
end

# Disable annoying Sidekiq logging in tests
Sidekiq.logger = nil

RSpec.configure do |config|
  config.around :each, sidekiq_inline: true do |example|
    Sidekiq::Testing.inline! do
      example.run
    end
  end
end

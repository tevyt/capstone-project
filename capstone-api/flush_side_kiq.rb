require 'sidekiq/api'

Sidekiq.redis{|conn| conn.flushdb}

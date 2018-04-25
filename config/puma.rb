require 'redis'

workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['MAX_THREADS'] || 2)
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 3001
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do
  $redis = Redis.new(url: ENV['REDISCLOUD_URL'] || 'redis://localhost:6379')
  $redis2 = Redis.new(url: ENV['REDISCLOUD_URL_2'] || 'redis://localhost:6379')
end
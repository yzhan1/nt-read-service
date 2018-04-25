require 'sinatra'
require 'zlib'
# require 'redis'

# $redis = Redis.new(url: ENV['REDISCLOUD_URL'] || 'redis://localhost:6379')
# $redis2 = Redis.new(url: ENV['REDISCLOUD_URL_2'] || 'redis://localhost:6379')

$writer = Sinatra::Base.production? ? 'https://nanotwitr.herokuapp.com' : 'http://localhost:9292'

get '/loaderio-6c73c6a2eea424fb0a1185fc2cc23844/' do
  'loaderio-6c73c6a2eea424fb0a1185fc2cc23844'
end

# Ian
get '/loaderio-6915226095daf0605fb5088f96a7ec8b/' do
  'loaderio-6915226095daf0605fb5088f96a7ec8b'
end

# write service
get '/loaderio-e70bc7cc9229c546018c143657c5ce53/' do
  'loaderio-e70bc7cc9229c546018c143657c5ce53'
end

# load balancer
get '/loaderio-dbccb84cd2f9c75a15a3c3e4479977d8/' do
  'loaderio-dbccb84cd2f9c75a15a3c3e4479977d8'
end

# read service 1
get '/loaderio-cb5b876def6d1805313fcb9b29ebd213/' do
  'loaderio-cb5b876def6d1805313fcb9b29ebd213'
end

# read service 2
get '/loaderio-6551bc7e87e4c846f9b7dcc62d4e21ea/' do
  'loaderio-6551bc7e87e4c846f9b7dcc62d4e21ea'
end

get '/' do
  id = params[:session_id]
  key = id ? "#{id}_timeline" : 'globaltimeline'
  get_cache(key, request, id)
end

get '/users/:id' do
  user_id = params[:id]
  key = user_id ? "#{user_id}_profile_page_li" : "#{user_id}_profile_page_lo"
  get_cache(key, request, params[:session_id])
end

get '/tweets/:id' do
  tweet_id = params[:id]
  key = tweet_id ? "#{tweet_id}_tweetpage_li" : "#{tweet_id}_tweetpage_lo"
  get_cache(key, request, params[:session_id])
end

def get_cache(key, req, id)
  cache = Time.now.to_i % 2 == 0 ? $redis.get(key) : $redis2.get(key)
  if cache.nil?
    puts 'redirecting'
    
    url = id ? "#{$writer}#{req.path_info}?session_id=#{id}" : "#{$writer}#{req.path_info}"
    redirect url
  else
    Zlib.inflate(cache)
  end
end
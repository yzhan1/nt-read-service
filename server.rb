require 'sinatra'
require 'zlib'
require 'newrelic_rpm'

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

get '/user/:id' do
  user_id = params[:id]
  user_id = 1001 if user_id == 'testuser'
  session_id = params[:session_id]
  key = session_id ? "#{user_id}_profile_page_li" : "#{user_id}_profile_page_lo"
  get_cache(key, request, session_id)
end

get '/tweets/:id' do
  tweet_id = params[:id]
  session_id = params[:session_id]
  key = session_id ? "#{tweet_id}_tweetpage_li" : "#{tweet_id}_tweetpage_lo"
  get_cache(key, request, session_id)
end

helpers do
  def get_cache(key, req, id)
    cache = fetch_from_redis(key)
    if cache.nil?
      puts "No cache for #{key}, redirecting"
      redirect(get_url(id, req))
    else
      puts "Found #{key} from cache"
      Zlib.inflate(cache)
    end
  end

  def fetch_from_redis(key)
    Time.now.to_i % 2 == 0 ? $redis.get(key) : $redis2.get(key)
  end

  def get_url(id, req)
    id ? "#{$writer}#{req.path_info}?session_id=#{id}" : "#{$writer}#{req.path_info}"
  end
end
require 'redis'
require 'zlib'
require_relative './spec_helper'

describe 'Read Service' do
  def app
    Sinatra::Application
  end

  before do
    $redis = $redis2 = Redis.new
    @redis_instances = [$redis, $redis2]
  end

  it 'should redirect to write service when no cache found for global timeline' do
    out, _ = capture_io { get '/' }
    assert out.include?('No cache')
    assert last_response.redirect?
  end

  it 'should return from cache when global timeline is in cache' do
    @redis_instances.each { |redis| redis.set('globaltimeline', Zlib.deflate('globaltimeline cache')) }
    out, _ = capture_io { get '/' }
    assert out.include?('Found')
    assert last_response.ok?
  end

  it 'should redirect to write service when no cache found for user timeline' do
    out, _ = capture_io { get '/?session_id=1' }
    assert out.include?('No cache')
    assert last_response.redirect?
  end

  it 'should return from cache when user timeline is in cache' do
    @redis_instances.each { |redis| redis.set('1_timeline', Zlib.deflate('user 1 timeline cache')) }
    out, _ = capture_io { get '/?session_id=1' }
    assert out.include?('Found')
    assert last_response.ok?
  end

  it 'should redirect to write service when no cache found for user page (logged out)' do
    out, _ = capture_io { get '/user/1' }
    assert out.include?('No cache')
    assert last_response.redirect?
  end

  it 'should return from cache when user page is in cache (logged out)' do
    @redis_instances.each { |redis| redis.set('1_profile_page_lo', Zlib.deflate('user 1 page cache')) }
    out, _ = capture_io { get '/user/1' }
    assert out.include?('Found')
    assert last_response.ok?
  end

  it 'should redirect to write service when no cache found for user page (logged in)' do
    out, _ = capture_io { get '/user/1?session_id=2' }
    assert out.include?('No cache')
    assert last_response.redirect?
  end

  it 'should return from cache when user page timeline is in cache (logged in)' do
    @redis_instances.each { |redis| redis.set('1_profile_page_li', Zlib.deflate('user 1 page cache')) }
    out, _ = capture_io { get '/user/1?session_id=2' }
    assert out.include?('Found')
    assert last_response.ok?
  end

  it 'should redirect to write service when no cache found for tweet page (logged out)' do
    out, _ = capture_io { get '/tweets/1' }
    assert out.include?('No cache')
    assert last_response.redirect?
  end

  it 'should return from cache when tweet page is in cache (logged out)' do
    @redis_instances.each { |redis| redis.set('1_tweetpage_lo', Zlib.deflate('tweet 1 page cache')) }
    out, _ = capture_io { get '/tweets/1' }
    assert out.include?('Found')
    assert last_response.ok?
  end

  it 'should redirect to write service when tweet page is not in cache (logged in)' do
    out, _ = capture_io { get '/tweets/1?session_id=2' }
    assert out.include?('No cache')
    assert last_response.redirect?
  end

  it 'should return from cache when tweet page is in cache (logged in)' do
    @redis_instances.each { |redis| redis.set('1_tweetpage_li', Zlib.deflate('tweet 1 page cache')) }
    out, _ = capture_io { get '/tweets/1?session_id=2' }
    assert out.include?('Found')
    assert last_response.ok?
  end

  after do
    @redis_instances.each { |redis| redis.flushall }
  end
end
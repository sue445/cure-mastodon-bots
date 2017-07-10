module CacheUtils
  require "global"

  module_function

  def fetch_cache(key)
    cache = cache_client

    begin
      cached_response = cache.get(key)
      return cached_response if cached_response
    rescue => e
      logger.warn(e)
      Rollbar.warning(e)
    end

    response = yield

    begin
      cache.set(key, response)
    rescue => e
      logger.warn(e)
      Rollbar.warning(e)
    end

    response
  end

  def cache_client
    return @cache_client if @cache_client

    options = { namespace: Global.memcached.namespace, compress: true, expires_in: Global.memcached.expire_minutes.minutes }

    Dalli.logger.level = Logger::WARN

    @cache_client =
      if ENV["MEMCACHEDCLOUD_SERVERS"]
        # Heroku
        options[:username] = ENV["MEMCACHEDCLOUD_USERNAME"]
        options[:password] = ENV["MEMCACHEDCLOUD_PASSWORD"]
        Dalli::Client.new(ENV["MEMCACHEDCLOUD_SERVERS"].split(","), options)
      else
        Dalli::Client.new("#{Global.memcached.host}:#{Global.memcached.port}", options)
      end
  end
end

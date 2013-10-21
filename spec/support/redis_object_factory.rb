class RedisObjectFactory
  attr_reader :type, :key, :ids, :id

  class << self
    attr_accessor :redis
  end

  def initialize(type_, ids_)
    @type = type_
    @ids = ids_
    @id = @ids.values.join("_")
    @key = "#{@type}_#{@id}"
    initial_data
    initial_set
  end

  def data
    data = Hash.new(0)
    data.merge(self.class.redis.hgetall @key)
  end

  def initial_data
    @initial_data ||= data
  end

  def initial_set
    @initial_set ||= set
  end

  def set
    set = Hash.new(0)
    set.merge(Hash[*$redis.zrange(key, 0, -1, withscores: true).flatten])
  end
end

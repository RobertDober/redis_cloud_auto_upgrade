# frozen_string_literal: true
# class level methods
module RedisCloudAutoUpgrade::ClassMethods
  def potential_upgrade!(conf, &blk)
    updated_conf = conf.merge(on_upgrade: blk)
    new
      .configure(updated_conf)
      .potential_upgrade!
  end
end

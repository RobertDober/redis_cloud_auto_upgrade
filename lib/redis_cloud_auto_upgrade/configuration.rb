# Configuration part
class RedisCloudAutoUpgrade
  Configuration = Struct.new(
    :heroku_api_key,
    :logger,
    :on_upgrade,
    :redis_cloud_id,
    :redis_instance,
    :treshhold
  ) do
    attr_reader :errors

    def configure(**values)
      values.each do |key, val|
        self[key] = val
      end
      self
    end

    def errors_human_readable
      return nil if @errors.empty?
      missing_fields
    end

    def valid?
      heroku_api_key.nil? && @errors.push([:missing, :heroku_api_key])
      redis_cloud_id.nil? && @errors.push([:missing, :redis_cloud_id])
      @errors.empty?
    end

    private

    def initialize
      self[:treshhold] = 0.5
      @errors = []
    end

    def missing_fields
      mf = @errors
           .select { |etype, _| etype == :missing }
           .map { |_, message| message }
      %(Missing required_fields: #{mf.inspect})
    end
  end
end

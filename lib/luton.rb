module Luton
  class Cache < Object
    def self.write(key, value, time_to_live = 4.hours, race_condition_ttl = 10.seconds)
      if value.class.to_s.include?('ActiveRecord_Relation')
        value = value.readonly(false).all
        value = value.to_a unless ['Array', 'WillPaginate::Collection'].include?(value.class.name)
      elsif value.class.to_s.include?('ActiveRecord::')
        value = value.to_a
      end

      unless Rails.cache.write(key, value, :expires_in => time_to_live, :race_condition_ttl => race_condition_ttl)
        Rails.logger.info("FAILED: Luton::Cache.write('#{key}'). Probably too big.")
      end
    end

    def self.read(key)
      if Rails.application.config.action_controller.perform_caching
        Rails.cache.read(key)
      end
    end

    def self.fetch(key, time_to_live = 4.hours)
      data = read(key)

      if !data && block_given?
        data = yield
        Luton::Cache.write(key, data, time_to_live)
      end

      data
    end

    def self.delete(key)
      Rails.cache.delete(key)
    end

  end
end

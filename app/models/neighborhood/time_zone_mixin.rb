class Neighborhood
  module TimeZoneMixin
    # This is probably not the end-result we're going for; but it is a start
    # We will probably want to fall-back to the current_person, then browser, then current_space time zones once we
    # gain access to them.
    def set_time_zone(&)
      Time.use_zone(ENV.fetch("NEIGHBORHOOD_TIME_ZONE"), &)
    end

    def self.included(controller_or_job)
      controller_or_job.around_action :set_time_zone
    end
  end
end

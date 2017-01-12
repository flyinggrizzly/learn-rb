# This allows us to save without updating the updated_at timestamp
# We do this because we cannot use update_column due to an Oracle drivers empty_clob() bug
# See http://blog.bigbinary.com/2009/01/21/override-automatic-timestamp-in-activerecord-rails.html
module ActiveRecord
  class Base
    def update_record_without_timestamping
      class << self
        def record_timestamps
          false
        end
      end

      save!

      class << self
        remove_method :record_timestamps
      end
    end
  end
end

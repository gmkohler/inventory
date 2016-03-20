module ActiveRecordExtension
  extend ActiveSupport::Concern
  module ClassMethods
    def pluck_to_hash(*keys)
      self.pluck(*keys).map {|vals| Hash[keys.zip(vals)]}
    end
  end
end

ActiveRecord::Base.send(:include, ActiveRecordExtension)

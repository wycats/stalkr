# dependencies are generated using a strict version, don't forget to edit the dependency versions when upgrading.
merb_gems_version = "1.0.7.1"
dm_gems_version   = "0.9.8"

# For more information about each component, please read http://wiki.merbivore.com/faqs/merb_components
dependency "merb-action-args", merb_gems_version
dependency "merb-assets", merb_gems_version  
dependency "merb-cache", merb_gems_version   
dependency "merb-helpers", merb_gems_version 
dependency "merb-mailer", merb_gems_version  
dependency "merb-slices", merb_gems_version  
dependency "merb-auth-core", merb_gems_version
dependency "merb-auth-more", merb_gems_version
dependency "merb-auth-slice-password", merb_gems_version
dependency "merb-param-protection", merb_gems_version
dependency "merb-exceptions", merb_gems_version
 
dependency "dm-core", dm_gems_version         
dependency "dm-aggregates", dm_gems_version   
dependency "dm-migrations", dm_gems_version   
dependency "dm-timestamps", dm_gems_version do
  module DataMapper
    module Timestamp
      private

      def set_timestamps
        return unless dirty? || new_record?
        TIMESTAMP_PROPERTIES.each do |name,(_type,proc)|
          if model.properties.has_property?(name)
            model.properties[name].set(self, proc.call(self, model.properties[name])) unless attribute_dirty?(name)
          end
        end
      end
      
      module ClassMethods
        def timestamps(*names)
          raise ArgumentError, 'You need to pass at least one argument' if names.empty?

          names.each do |name|
            case name
              when *TIMESTAMP_PROPERTIES.keys
                type = TIMESTAMP_PROPERTIES[name].first
                property name, type, :nullable => false, :auto_validation => false
              when :at
                timestamps(:created_at, :updated_at)
              when :on
                timestamps(:created_on, :updated_on)
              else
                raise InvalidTimestampName, "Invalid timestamp property name '#{name}'"
            end
          end
        end
      end
    end
  end # module ClassMethods  
end  
dependency "dm-types", dm_gems_version        
dependency "dm-validations", dm_gems_version  
dependency "dm-sweatshop", dm_gems_version

dependency "merb_datamapper", merb_gems_version
dependency "do_sqlite3" # If using another database, replace this
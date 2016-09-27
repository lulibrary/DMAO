module Configuration
  module System
    class CrisSystem

      include ActiveModel::Model

      attr_accessor :system_id, :config_values

      validates :system_id, numericality: true
      validate :config_values_array

      def initialize(attributes={})

        attributes = clean_up_attributes attributes

        super

        if @config_values.nil? || @config_values.empty? || !@config_values.is_a?(Array)
          @config_values = []
        end

      end

      def add_config_value id
        @config_values.push id
      end

      def remove_config_value id
        @config_values.delete id
      end

      def details

        begin
          ::Systems::CrisSystem.find(self.system_id)
        rescue ActiveRecord::RecordNotFound
          nil
        end

      end

      def configuration_values

        self.config_values.map do |v|

          begin
            ::Systems::ConfigurationValue.find(v)
          rescue ActiveRecord::RecordNotFound
            nil
          end

        end

      end

      private

      def config_values_array
        errors.add(:config_values, 'Must be an array of config value ids') unless config_values.is_a?(Array)
      end

      def clean_up_attributes attributes

        attributes = attributes.dup unless attributes.nil?

        attributes = remove_nil_attributes attributes

        attributes.delete(:configuration_key_values) unless attributes.nil?

        attributes

      end

      def remove_nil_attributes attributes

        return attributes unless attributes.present?

        attributes.each do |k,v|

          v.nil? ? attributes.delete(k) : ''

        end

        attributes

      end

    end
  end
end
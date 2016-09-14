module Configuration
  module System
    class CrisSystem

      include ActiveModel::Model

      attr_accessor :system_id, :config_values

      validates :system_id, numericality: true
      validates :config_values, presence: true
      validate :config_values_array

      def initialize(attributes={})
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

      private

      def config_values_array
        errors.add(:config_values, 'Must be an array of config value ids') unless config_values.is_a?(Array)
      end

    end
  end
end
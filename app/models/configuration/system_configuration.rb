module Configuration
  class SystemConfiguration

    include ActiveModel::Model

    attr_accessor :cris_system

    validate :has_a_cris_system

    def initialize(attributes={})

      super

      if !@cris_system.is_a?(Configuration::System::CrisSystem)
        @cris_system = Configuration::System::CrisSystem.new(@cris_system)
      end

    end

    private

    def has_a_cris_system
      errors.add(:cris_system, 'CRIS System configuration must be an instance of Configuration::System::CrisSystem') unless @cris_system.is_a?(Configuration::System::CrisSystem)
    end

  end
end
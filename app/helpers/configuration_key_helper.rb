module ConfigurationKeyHelper

  def configuration_key_id_name id

    begin

      key = Systems::ConfigurationKey.find(id)

      key.display_name

    rescue ActiveRecord::RecordNotFound

      nil

    end

  end

  def configuration_key_id_slug id

    begin

      key = Systems::ConfigurationKey.find(id)

      key.name

    rescue ActiveRecord::RecordNotFound

      nil

    end

  end

  def configuration_key_id_secure id

    begin

      false

    rescue ActiveRecord::RecordNotFound

      nil

    end

  end

end
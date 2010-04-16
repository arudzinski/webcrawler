module ParamsToConditions
  private

  def get_conditions_from_params(*args)
    args.inject({}) do |conditions_hash, key|
      field = key.is_a?(Array) ? key.last : key
      value = key.is_a?(Array) ? params[key.first] : params[key]
      conditions_hash.merge!({field.to_s => value}) if value
      conditions_hash
    end || {}
  end

end